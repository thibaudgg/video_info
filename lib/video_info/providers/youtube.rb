class VideoInfo
  module Providers
    class Youtube < Provider

      def self.usable?(url)
        url =~ /(youtube\.com\/(?!playlist|embed\/videoseries).*)|(youtu\.be)/
      end

      def provider
        'YouTube'
      end

      def title
        _video_entry['title']['$t']
      end

      %w[description keywords].each do |method|
        define_method(method) { _video_media_group["media$#{method}"]['$t'] }
      end

      %w[width height].each do |method|
        define_method(method) { nil }
      end

      def duration
        _video_media_group['yt$duration']['seconds'].to_i
      end

      def embed_url
        "//www.youtube.com/embed/#{video_id}"
      end

      def date
        Time.parse(_video_entry['published']['$t'], Time.now.utc)
      end

      def thumbnail_small
        _video_thumbnail(0)
      end

      def thumbnail_medium
        _video_thumbnail(1)
      end

      def thumbnail_large
        _video_thumbnail(2)
      end

      def view_count
        _video_entry['yt$statistics'] ? _video_entry['yt$statistics']['viewCount'].to_i : 0
      end

      private

      def _url_regex
        /(?:youtube(?:-nocookie)?\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/ ]{11})/i
      end

      def _api_base
        "gdata.youtube.com"
      end

      def _api_path
        "/feeds/api/videos/#{video_id}?v=2&alt=json"
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

      def _video_entry
        data['entry']
      end

      def _video_media_group
        data['entry']['media$group']
      end

      def _video_thumbnail(id)
        _video_entry['media$group']['media$thumbnail'][id]['url']
      end

    end
  end
end
