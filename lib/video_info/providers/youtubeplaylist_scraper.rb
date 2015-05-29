require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'

class VideoInfo
  module Providers
    module YoutubePlaylistScraper
      def description
	data.css('meta').find { |m| m.values[0] == 'description' }.values[1]
      end
      
      def title
	data.css('meta').find { |m| m.values[0] == 'title' }.values[1]
      end
      
      def videos
	raise(NotImplementedError, 'To access videos, you must provide an API key to VideoInfo.provider_api_keys')
      end
      
      def thumbnail_small
	thumbnail_medium.sub('mqdefault.jpg', 'default.jpg')
      end

      def thumbnail_medium
	'https:' + data.css('div.pl-header-thumb img').attr('src').value
      end
      
      def thumbnail_large
	thumbnail_medium.sub('mqdefault.jpg', 'hqdefault.jpg')
      end

      private

      def _set_data_from_api(api_url = _api_url)
	Nokogiri::HTML(open(api_url, :allow_redirections => :safe))
      end

      def _api_url
	@url
      end
    end
  end
end
