class VideoInfo
  module Providers
    class YoutubePlaylist < Youtube

      alias_method :playlist_id, :video_id
      attr_accessor :playlist_items_data

      def self.usable?(url)
        url =~ /((youtube\.com)\/playlist)|((youtube\.com)\/embed\/videoseries)/
      end

      def description
        data['items'][0]['snippet']['description']
      end

      def videos
        _playlist_video_ids.map do |entry_id|
          VideoInfo.new("http://www.youtube.com/watch?v=#{entry_id}")
        end
      end

      def embed_url
        "//www.youtube.com/embed/videoseries?list=#{playlist_id}"
      end

      %w[date keywords duration view_count].each do |method|
        define_method(method) { nil }
      end

      private

      def _playlist_entry
        data['items']
      end

      def _playlist_items
        data['items']
      end

      def _url_regex
        /youtube.com\/playlist\?p=(\S*)|youtube.com\/embed\/videoseries\?list=([a-zA-Z0-9-]*)/
      end

      def _api_path
        "/youtube/v3/playlists?part=snippet&id=#{playlist_id}&key=#{api_key}"
      end

      def _playlist_items_api_path
        "/youtube/v3/playlistItems?part=snippet&playlistId=#{playlist_id}&fields=items&key=#{api_key}"
      end

      def _playlist_items_api_url
        "https://#{_api_base}#{_playlist_items_api_path}"
      end

      def _playlist_items_data
        @playlist_items_data ||= _set_data_from_api(_playlist_items_api_url)
      end

      def _playlist_video_ids
        _playlist_items_data['items'].map do |item|
          item['snippet']['resourceId']['videoId']
        end
      end
    end
  end
end
