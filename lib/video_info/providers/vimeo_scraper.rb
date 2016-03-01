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
        d = data.css('script')[6].text.split('window.vimeo.clip_page_config =')[1]
        JSON.parse(d.split(";\n")[0])['owner']['portrait']['src']
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
        keywords_str = ''

        json_info['keywords'].each { |keyword| keywords_str << keyword << ", " }

        keywords_str.chop.chop # remove trailing ", "
      end

      def height
        meta_node_value('og:video:height').to_i
      end

      def width
        meta_node_value('og:video:width').to_i
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

      def available?
        super
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
        Oga.parse_html(open(api_url.to_s, allow_redirections: :safe).read)
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

