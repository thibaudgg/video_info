require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'

class VideoInfo
  module Providers
    module YoutubePlaylistScraper
      def description
	data.css('meta')[1].values[1]
      end
      
      def title
	data.css('meta')[0].values[1]
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
