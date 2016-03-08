require_relative 'youtubeplaylist_api'
require_relative 'youtubeplaylist_scraper'

class VideoInfo
  module Providers
    class YoutubePlaylist < Youtube
      alias_method :playlist_id, :video_id
      attr_accessor :playlist_items_data

      def initialize(url, options = {})
        super(url, options)

        if VideoInfo.provider_api_keys[:youtube].nil?
          extend YoutubePlaylistScraper
        else
          extend YoutubePlaylistAPI
        end
      end

      def self.usable?(url)
        url =~ %r{((youtube\.com)\/playlist)|
                  ((youtube\.com)\/embed\/videoseries)}x
      end

      def date
        nil
      end

      def duration
        nil
      end

      def keywords
        nil
      end

      def view_count
        nil
      end

      def embed_url
        "//www.youtube.com/embed/videoseries?list=#{playlist_id}"
      end

      %w[date keywords duration view_count].each do |method|
        define_method(method) { nil }
      end

      private

      def _url_regex
        %r{youtube.com\/playlist\?p=(\S*)|
          youtube.com\/playlist\?list=(\S*)|
          youtube.com\/embed\/videoseries\?list=([a-zA-Z0-9-]*)}x
      end
    end
  end
end
