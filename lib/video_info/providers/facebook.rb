require 'json'

class VideoInfo
  module Providers
    class Facebook < Provider
      def self.usable?(url)
        url =~ %r{(facebook\.com\/.*/videos/.*)|
                  (facebook\.com/.*\%2Fvideos%2F)}x
      end

      def author
        data['from']['name']
      end

      def author_thumbnail
      end

      def author_url
        'https://www.facebook.com/' + data['from']['id']
      end

      def duration
        data['length'].round.to_i
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
        'v2.5'
      end

      def _api_path
        "/#{_api_version}/#{video_id}?fields=from,length" \
        "&access_token=#{_app_id}|#{_app_secret}"
      end

      def _api_url
        "https://#{_api_base}#{_api_path}"
      end

      def _app_id
        VideoInfo.provider_api_keys[:facebook_app_id]
      end

      def _app_secret
        VideoInfo.provider_api_keys[:facebook_app_secret]
      end
    end
  end
end
