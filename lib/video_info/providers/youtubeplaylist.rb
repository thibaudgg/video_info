class VideoInfo
  module Providers
    class YoutubePlaylist < Youtube

      alias_method :playlist_id, :video_id

      def self.usable?(url)
        url =~ /((youtube\.com)\/playlist)|((youtube\.com)\/embed\/videoseries)/
      end

      def videos
        _playlist_video_ids.map do |entry_id|
          VideoInfo.new("http://www.youtube.com/watch?v=#{entry_id}")
        end
      end

      def embed_url
        "//www.youtube.com/embed/videoseries?list=#{playlist_id}"
      end

      def description
        _playlist_entry['subtitle']['$t']
      end

      %w[date keywords duration view_count].each do |method|
        define_method(method) { nil }
      end

      private

      def _playlist_entry
        data['feed']
      end

      def _video_entry
        _playlist_entry
      end

      def _url_regex
        /youtube.com\/playlist\?p=(\S*)|youtube.com\/embed\/videoseries\?list=([a-zA-Z0-9-]*)/
      end

      def _api_path
        "/feeds/api/playlists/#{playlist_id}?v=2&alt=json"
      end

      def _playlist_video_ids
        return [] unless _playlist_entry['entry']
        _playlist_entry['entry'].map do |entry|
          entry['media$group']['yt$videoid']['$t']
        end
      end

    end
  end
end
