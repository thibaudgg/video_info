require 'oga'
require 'open-uri'
require 'json'

class VideoInfo
  module Providers
    module VimeoScraper
      def author
        json_info['author']['name']
      end

      def author_thumbnail
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
        json_info['author']['url']
      end

      def available?
        is_available = super

        if is_available
          page_header = data.css('#page_header')

          if page_header.text == "\n Private Video\n "
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
        upload_date = json_info['uploadDate']
        ISO8601::DateTime.new(upload_date).to_time
      end

      def duration
        duration = json_info['duration']
        ISO8601::Duration.new(duration).to_seconds.to_i
      end

      def keywords
        json_info['keywords']
      end

      def height
        json_info['height']
      end

      def width
        json_info['width']
      end

      def thumbnail_small
        thumbnail_url.split('_')[0] + '_100x75.jpg'
      end

      def thumbnail_medium
        thumbnail_url.split('_')[0] + '_200x150.jpg'
      end

      def thumbnail_large
        thumbnail_url.split('_')[0] + '_640.jpg'
      end

      def view_count
        json_info['interactionCount']
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
        @thumbnail_url ||= json_info['thumbnailUrl']
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
