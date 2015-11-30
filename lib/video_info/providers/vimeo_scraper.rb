require 'oga'
require 'open-uri'

class VideoInfo
  module Providers
    module VimeoScraper
      def author
        author_element = data.css('a').detect { |n| n.attr('rel').value == 'author' }

        author_element.value
      end

      def title
        meta_node_value('og:title')
      end

      def description
        meta_node_value('og:description')
      end

      def duration
        nil
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

      private

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

