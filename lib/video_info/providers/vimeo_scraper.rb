require 'oga'
require 'open-uri'
require 'json'

class VideoInfo
  module Providers
    module VimeoScraper
      def author
        author_element = data.css('a').detect do |n|
          rel = n.attr('rel')

          if rel.nil?
            false
          else
            rel.value == 'author'
          end
        end

        author_element.text
      end

      def author_thumbnail
        data.css('img.portrait').attr('src')[0].value
      end

      def title
        meta_node_value('og:title')
      end

      def description
        meta_node_value('og:description')
      end

      def date
        ISO8601::DateTime.new(json_script['uploadDate']).to_time
      end

      def duration
        ISO8601::Duration.new(json_script['duration']).to_seconds.to_i
      end

      def keywords
        keyword_elements = meta_nodes.find_all do |n|
          property = n.attr('property')

          if property.nil?
            false
          else
            property.value == 'video:tag'
          end
        end

        keywords = keyword_elements.map { |e| e.attr('content').value }

        keywords_string = ''

        keywords.each { |keyword| keywords_string << keyword << ', ' }

        keywords_string[0..-3]
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
        raise(NotImplementedError, 'To access view_count, you must provide an API key to VideoInfo.provider_api_keys')
      end

      private

      def json_script
        @json_script ||= JSON.parse(data.css('script').detect do |n|
          type = n.attr('type')

          if type.nil?
            false
          else
            type.value == 'application/ld+json'
          end
        end.text)[0]
      end

      def thumbnail_url
        @thumbnail_url ||= json_script['thumbnailUrl']
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

      def available?
        true
      end

      def _set_data_from_api_impl(api_url)
        Oga.parse_html(open(api_url, allow_redirections: :safe).read)
      end

      def _api_url
        @url
      end
    end
  end
end

