class VideoInfo
  module Providers
    class Wistia < Provider
      def self.usable?(url)
        url =~ /(.*)(wistia.com|wistia.net|wi.st)/
      end

      def provider
        'Wistia'
      end

      %w[title duration width height].each do |method|
        define_method(method) { data[method] }
      end

      %w[description keywords view_count date].each do |method|
        define_method(method) { nil }
      end

      def embed_url
        "//fast.wistia.net/embed/iframe/#{video_id}"
      end

      def thumbnail_small
        data['thumbnail_url']
      end

      def thumbnail_medium
        data['thumbnail_url']
      end

      def thumbnail_large
        data['thumbnail_url']
      end

      private

      def _url_regex
        %r{(?:.*)(?:wistia.com|wi.st|wistia.net)
           \/(?:embed\/)?(?:medias\/)?(?:iframe\/)?(.+)}x
      end

      def _api_base
        'fast.wistia.com'
      end

      def _api_path
        "/oembed?url=http%3A%2F%2Fhome.wistia.com%2Fmedias%2F#{video_id}"
      end

      def _api_url
        "http://#{_api_base}#{_api_path}"
      end

      def _default_iframe_attributes
        {}
      end

      def _default_url_attributes
        {}
      end
    end
  end
end
