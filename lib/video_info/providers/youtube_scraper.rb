require 'oga'
require 'open-uri'

class VideoInfo
  module Providers
    module YoutubeScraper
      def date
        if available?
          date_published_node = meta_nodes.detect do |m|
            itemprop_attr = m.attr('itemprop')

            itemprop_attr.value == 'datePublished' unless !itemprop_attr
          end

          Time.parse(date_published_node.attr('content').value)
        end
      end

      def description
        meta_node_value('description')
      end

      def duration
        if available?
          duration_node = meta_nodes.detect do |m|
            itemprop_attr = m.attr('itemprop')

            itemprop_attr.value == 'duration' unless !itemprop_attr
          end

          duration = duration_node.attr('content').value

          ISO8601::Duration.new(duration).to_seconds.to_i
        else
          0
        end
      end

      def keywords
        value = meta_node_value('keywords')

        value.split(', ') unless !value
      end

      def title
        meta_node_value('title')
      end

      def thumbnail_small
        "https://i.ytimg.com/vi/#{video_id}/default.jpg"
      end

      def thumbnail_medium
        "https://i.ytimg.com/vi/#{video_id}/mqdefault.jpg"
      end

      def thumbnail_large
        "https://i.ytimg.com/vi/#{video_id}/hqdefault.jpg"
      end

      def view_count
        data.css('div.watch-view-count').text.gsub(',', '').to_i
      end

      private

      def meta_nodes
        @meta_nodes ||= data.css('meta')
      end

      def meta_node_value(name)
        if available?
          node = meta_nodes.detect { |n| n.attr('name').value == name }

          node.attr('content').value
        end
      end

      def available?
        data.css('div#unavailable-submessage').text.strip.empty?
      end

      def _set_data_from_api(api_url = _api_url)
        Oga.parse_html(open(api_url, allow_redirections: :safe))
      end

      def _api_url
        @url
      end
    end
  end
end