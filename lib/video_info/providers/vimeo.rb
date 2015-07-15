class VideoInfo
  module Providers
    class Vimeo < Provider
      def self.usable?(url)
        url =~ /(vimeo\.com\/(?!album|hubnut\/album).*)/
      end

      def provider
        'Vimeo'
      end

      %w[title description thumbnail_small thumbnail_medium thumbnail_large].each do |method|
        define_method(method) { _video[method] }
      end

      %w[duration width height].each do |method|
        define_method(method) { _video[method].to_i }
      end

      def keywords
        _video['tags']
      end

      def embed_url
        "//player.vimeo.com/video/#{video_id}"
      end

      def date
        Time.parse(_video['upload_date'], Time.now.utc).utc
      end

      def view_count
        _video['stats_number_of_plays'].to_i
      end

      def author_thumbnail
        _video['user_portrait_huge']
      end

      def author_domain
        get_host_without_www(_video['user_url']) if _video['user_url']
      end

      def author
        _video['user_name']
      end

      private

      def _video
        data && data.first
      end

      def _url_regex
        /.*\.com\/(?:(?:groups\/[^\/]+\/videos\/)|(?:ondemand|channels)(?:(?:\/less\/)|(?:\/\w*\/))|(?:video\/))?([0-9]+).*$/
      end

      def _api_base
        'vimeo.com'
      end

      def _api_path
        "/api/v2/video/#{video_id}.json"
      end

      def _api_url
        "http://#{_api_base}#{_api_path}"
      end

      def _default_iframe_attributes
        {}
      end

      def _default_url_attributes
        { title: 0,
          byline: 0,
          portrait: 0,
          autoplay: 0 }
      end
    end
  end
end
