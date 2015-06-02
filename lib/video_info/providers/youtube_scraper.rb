require 'oga'
require 'open-uri'

class VideoInfo
  module Providers
    module YoutubeScraper
      def date
        meta_nodes = data.css('meta')

        date_published_node = meta_nodes.detect do |m|
          itemprop_attr = m.attr('itemprop')

          itemprop_attr.value == 'datePublished' unless !itemprop_attr
        end

        Time.parse(date_published_node.attr('content').value)
      end

      def description
        if available?
          meta_nodes = data.css('meta')

          description_node = meta_nodes.detect do |m|
            m.attr('name').value == 'description'
          end

          description_node.attr('content').value
        else
          nil
        end
      end

      def keywords
        if available?
          meta_nodes = data.css('meta')

          description_node = meta_nodes.detect do |m|
            m.attr('name').value == 'keywords'
          end

          description_node.attr('content').value
        else
          nil
        end
      end

      def title
        if available?
          meta_nodes = data.css('meta')

          title_node = meta_nodes.detect do |m|
            m.attr('name').value == 'title'
          end

          title_node.attr('content').value
        else
          nil
        end
      end

      def thumbnail_small
        return "https://i.ytimg.com/vi/#{video_id}/default.jpg"
      end

      def thumbnail_medium
        return "https://i.ytimg.com/vi/#{video_id}/mqdefault.jpg"
      end

      def thumbnail_large
        return "https://i.ytimg.com/vi/#{video_id}/hqdefault.jpg"
      end

      def view_count
        data.css('div.watch-view-count').text.gsub(',', '').to_i
      end

      private

      def available?
        data.css('div#unavailable-submessage').text.strip.empty?
      end

      def _set_data_from_api(api_url = _api_url)
        Oga.parse_html(open(api_url, :allow_redirections => :safe))
      end

      def _api_url
        @url
      end
    end
  end
end
