class VideoInfo
  module Providers
    class Vimeo < Provider
      def self.usable?(url)
        url =~ /(vimeo\.com\/(?!album|hubnut\/album).*)/
      end

      def provider
        'Vimeo'
      end

      def api_key
        VideoInfo.provider_api_keys[:vimeo]
      end

      %w[description].each do |method|
        define_method(method) { _video[method] }
      end

      %w[duration width height].each do |method|
        define_method(method) { _video[method].to_i }
      end

      def title
        _video['name']
      end

      def thumbnail_small
        "https://i.vimeocdn.com/video/#{video_id}_100x75.jpg"
      end

      def thumbnail_medium
        "https://i.vimeocdn.com/video/#{video_id}_200x150.jpg"
      end

      def thumbnail_large
        "https://i.vimeocdn.com/video/#{video_id}_640.jpg"
      end

      def keywords
        keywords_array.join(', ')
      end

      def keywords_array
        _video['tags'].map { |t| t["tag"] }
      end

      def embed_url
        "//player.vimeo.com/video/#{video_id}"
      end

      def date
        Time.parse(_video['created_time'], Time.now.utc).utc
      end

      def view_count
        _video['stats']["plays"].to_i
      end

      private

      def _clean_options(options)
        headers = [super, _authorization_headers, _api_version_headers]
        headers.inject(&:merge)
      end

      def _api_version
        "3.2"
      end

      def _authorization_headers
        { "Authorization" => "bearer #{api_key}" }
      end

      def _api_version_headers
        { "Accept" => "application/vnd.vimeo.*+json;version=#{_api_version}"}
      end

      def _video
        data
      end

      def _url_regex
        /.*\.com\/(?:(?:groups\/[^\/]+\/videos\/)|(?:ondemand|channels)(?:(?:\/less\/)|(?:\/\w*\/))|(?:video\/))?([0-9]+).*$/
      end

      def _api_base
        'api.vimeo.com'
      end

      def _api_path
        "/videos/#{video_id}"
      end

      def _api_url
        "https://#{_api_base}#{_api_path}"
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