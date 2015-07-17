class VideoInfo
  module Providers
    class VimeoPlaylist < Vimeo
      alias_method :playlist_id, :video_id

      def self.usable?(url)
        url =~ /((vimeo\.com)\/album)|((vimeo\.com)\/hubnut\/album)/
      end

      def videos
        @videos ||= _data_videos.map do |video_data|
          video = Vimeo.new(video_data['link'])
          video.data = video
          video
        end
      end

      def embed_url
        "//player.vimeo.com/hubnut/album/#{playlist_id}"
      end

      %w[width height keywords view_count].each do |method|
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
        "/albums/#{playlist_id}"
      end

      def _api_path_album_videos
        "/albums/#{playlist_id}/videos"
      end

      def _api_videos_path
        "/videos/#{video_id}"
      end

      def _api_videos_url
        "https://#{_api_base}#{_api_path_album_videos}"
      end

      def _data_videos
        @data_videos ||= _set_videos_from_api
      end

      def _set_videos_from_api
        uri = open(_api_videos_url, options)
        json = MultiJson.load(uri.read)
        json['data']
      end
    end
  end
end
