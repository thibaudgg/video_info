class VideoInfo
  module Providers
    class VimeoPlaylist < Vimeo

      alias_method :playlist_id, :video_id

      def self.usable?(url)
        url =~ /((vimeo\.com)\/album)|((vimeo\.com)\/hubnut\/album)/
      end

      def videos
        _playlist_video_ids.map do |entry_id|
          VideoInfo.new("http://vimeo.com/#{entry_id}")
        end
      end

      def embed_url
        "//player.vimeo.com/hubnut/album/#{playlist_id}"
      end

      %w[width height date keywords duration view_count].each do |method|
        define_method(method) { nil }
      end

      private

      def _video
        data
      end

      def _url_regex
        /vimeo.com\/album\/([0-9]*)|vimeo.com\/hubnut\/album\/([0-9]*)/
      end

      def _api_path
        "/api/v2/album/#{video_id}/info.json"
      end

      def _api_videos_path
        "/api/v2/album/#{video_id}/videos.json"
      end

      def _api_videos_url
        "http://#{_api_base}#{_api_videos_path}"
      end

      def _data_videos
        @data_videos ||= _set_videos_from_api
      end

      def _set_videos_from_api
        uri = open(_api_videos_url, options)
        MultiJson.load(uri.read)
      end

      def _playlist_video_ids
        _data_videos.map do |entry|
          entry['id']
        end
      end

    end
  end
end
