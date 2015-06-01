require 'oga'
require 'open-uri'
require 'open_uri_redirections'

class VideoInfo
  module Providers
    module YoutubePlaylistScraper
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

      def videos
        raise(NotImplementedError, 'To access videos, you must provide an API key to VideoInfo.provider_api_keys')
      end

      def thumbnail_small
        thumbnail_medium.sub('mqdefault.jpg', 'default.jpg')
      end

      def thumbnail_medium
        'https:' + data.css('div.pl-header-thumb img').attr('src')[0].value
      end

      def thumbnail_large
        thumbnail_medium.sub('mqdefault.jpg', 'hqdefault.jpg')
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
