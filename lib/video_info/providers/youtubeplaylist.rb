class VideoInfo
  module Providers
    class YoutubePlaylist < Provider

      alias_method :playlist_id, :video_id

      def self.usable?(url)
        url =~ /(youtube\.com)\/playlist/
      end

      def provider
        'YouTubePlaylist'
      end

      def videos
        _playlist_video_ids.map do |entry_id|
          VideoInfo.new("http://www.youtube.com/watch?v=#{entry_id}")
        end
      end

      def title
        _playlist_entry['title']['$t']
      end

      def thumbnail_small
        _playlist_thumbnail(0)
      end

      def thumbnail_medium
        _playlist_thumbnail(1)
      end

      def thumbnail_large
        _playlist_thumbnail(2)
      end

      def embed_url
        "www.youtube.com/embed/videoseries?list=#{playlist_id}"
      end

      private

      def _playlist_entry
        data['feed']
      end

      def _playlist_thumbnail(id)
        _playlist_entry['media$group']['media$thumbnail'][id]['url']
      end

      def _url_regex
        /youtube.com\/playlist\?p=(\S*)/
      end

      def _api_base
        "gdata.youtube.com"
      end

      def _api_path
        "/feeds/api/playlists/#{playlist_id}?v=2&alt=json"
      end

      def _api_url
        "http://#{_api_base}#{_api_path}"
      end

      def _default_iframe_attributes
        { allowfullscreen: "allowfullscreen" }
      end

      def _default_url_attributes
        {}
      end

      def _playlist_video_ids
        _playlist_entry['entry'].map do |entry|
          entry['media$group']['yt$videoid']['$t']
        end
      end

    end
  end
end
