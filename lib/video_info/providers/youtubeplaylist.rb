require_relative 'youtubeplaylist_api'

class VideoInfo
  module Providers
    class YoutubePlaylist < Youtube
      alias_method :playlist_id, :video_id
      attr_accessor :playlist_items_data

      def initialize(url, options = {})
        extend YoutubePlaylistAPI

        super(url, options)
      end

      def self.usable?(url)
        url =~ /((youtube\.com)\/playlist)|((youtube\.com)\/embed\/videoseries)/
      end

      def embed_url
        "//www.youtube.com/embed/videoseries?list=#{playlist_id}"
      end

      %w[date keywords duration view_count].each do |method|
        define_method(method) { nil }
      end

      private

      def _url_regex
        /youtube.com\/playlist\?p=(\S*)|youtube.com\/embed\/videoseries\?list=([a-zA-Z0-9-]*)/
      end
    end
  end
end
