require 'oga'
require 'open-uri'

class VideoInfo
  module Providers
    module YoutubeScraper
      def description
        meta_nodes = data.css('meta')

        description_node = meta_nodes.detect do |m|
          m.attr('name').value == 'description'
        end

        description_node.attr('content').value
      end

      def title
        meta_nodes = data.css('meta')

        title_node = meta_nodes.detect do |m|
          m.attr('name').value == 'title'
        end

        title_node.attr('content').value
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

      private

      def available?
        !data.css('div#page').attr('class')[0].value.include?('oops-content')
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
