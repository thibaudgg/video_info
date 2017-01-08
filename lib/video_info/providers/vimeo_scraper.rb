require 'oga'
require 'open-uri'
require 'json'
require 'openssl'
require 'cgi'

class VideoInfo
  module Providers
    module VimeoScraper
      def author
        if available?
          json_info['author']['name']
        end
      end

      def author_thumbnail
        unless available?
          return nil
        end

        split_point = 'window.vimeo.clip_page_config ='
        script_tags = data.css('script')

        script_index = script_tags.find_index do |x|
          x.text.include?(split_point)
        end

        script_text = script_tags[script_index].text

        split_script_text = script_text.split(split_point)[1]

        parsed_data = JSON.parse(split_script_text.split(";\n")[0])

        parsed_data['owner']['portrait']['src']
      end

      def author_url
        if available?
          json_info['author']['url']
        end
      end

      def available?
        is_available = super

        if data.nil?
          is_available = false
        elsif is_available
          password_elements = data.css('.exception_title--password')

          unless password_elements.empty?
            is_available = false
          end
        end

        is_available
      end

      def title
        meta_node_value('og:title')
      end

      def description
        meta_node_value('og:description')
      end

      def date
        if available?
          upload_date = json_info['uploadDate']
          ISO8601::DateTime.new(upload_date).to_time
        end
      end

      def duration
        if available?
          duration = json_info['duration']
          ISO8601::Duration.new(duration).to_seconds.to_i
        end
      end

      def keywords
        unless available?
          return nil
        end

        if json_info['keywords']
          json_info['keywords']
        else
          []
        end
      end

      def height
        if available?
          json_info['height']
        end
      end

      def width
        if available?
          json_info['width']
        end
      end

      def thumbnail_small
        if available?
          thumbnail_url.split('_')[0] + '_100x75.jpg'
        end
      end

      def thumbnail_medium
        if available?
          thumbnail_url.split('_')[0] + '_200x150.jpg'
        end
      end

      def thumbnail_large
        if available?
          thumbnail_url.split('_')[0] + '_640.jpg'
        end
      end

      def view_count
        if available?
          json_info['interactionCount']
        end
      end

      private

      def json_info
        @json_info ||= JSON.parse(data.css('script').detect do |n|
          type = n.attr('type')

          if type.nil?
            false
          else
            type.value == 'application/ld+json'
          end
        end.text)[0]
      end

      def thumbnail_url
        @thumbnail_url ||= remove_overlay(meta_node_value('og:image'))
      end

      def remove_overlay(url)
        uri = URI.parse(url)
        
        if uri.path == '/filter/overlay'
          CGI::parse(uri.query)['src0'][0]
        else
          url
        end
      end

      def meta_nodes
        @meta_nodes ||= data.css('meta')
      end

      def meta_node_value(name)
        if available?
          node = meta_nodes.detect do |n|
            property = n.attr('property')

            if property.nil?
              false
            else
              property.value == name
            end
          end

          node.attr('content').value
        end
      end

      def _set_data_from_api_impl(api_url)
        Oga.parse_html(open(api_url.to_s).read)

      rescue OpenURI::HTTPError
        nil
      end

      def _api_url
        uri = URI.parse(@url)
        uri.scheme = 'https'
        uri.to_s
      end

      def _api_path
        _api_url
      end
    end
  end
end
