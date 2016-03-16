class VideoInfo
  module Providers
    class Facebook < Provider
      def self.usable?(url)
        url =~ %r{(facebook\.com\/.*/videos/.*)|
                  (facebook\.com/.*\%2Fvideos%2F)}x
      end

      def author
        data
      end

      def author_thumbnail
        data
      end

      def author_url
        data
      end

      private

      def available?
        true
      end

      def _url_regex
        %r{(?:.*facebook\.com\/.*\/videos\/(.*)/)}
      end

      def _api_base
        'graph.facebook.com'
      end

      def _api_version
        '2.5'
      end

      def _api_path
        "/#{_api_version}/#{video_id}"
      end

      def _api_url
        "https://#{_api_base}#{_api_path}"
      end
    end
  end
end
