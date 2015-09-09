require_relative 'vimeo_api'

class VideoInfo
  module Providers
    class Vimeo < Provider
      def initialize(url, options = {})
        extend VimeoAPI

        super(url, options)
      end

      def self.usable?(url)
        url =~ /(vimeo\.com\/(?!album|hubnut\/album).*)/
      end

      def provider
        'Vimeo'
      end

      def embed_url
        "//player.vimeo.com/video/#{video_id}"
      end

      private

      def _clean_options(options)
        headers = [super, _authorization_headers, _api_version_headers]
        headers.inject(&:merge)
      end

      def _api_version
        '3.2'
      end

      def _authorization_headers
        { 'Authorization' => "bearer #{api_key}" }
      end

      def _api_version_headers
        { 'Accept' => "application/vnd.vimeo.*+json;version=#{_api_version}" }
      end

      def _video
        data
      end

      def _url_regex
        /.*\.com&&
        |\/(?:(?:groups\/[^\/]+\/videos\/)
        |(?:ondemand|channels)(?:(?:\/less\/)
        |(?:user[0-9]+\/review\/)?([0-9]+).*
        |(?:\/\w*\/))|(?:video\/))?([0-9]+).*$
        /x
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

      def _parse_picture_id(uri)
        /\/pictures\/(\d+)/.match(uri)[1]
      end
    end
  end
end
