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

      def _url_regex
        /.*\.com&&
        |\/(?:(?:groups\/[^\/]+\/videos\/)
        |(?:ondemand|channels)(?:(?:\/less\/)
        |(?:user[0-9]+\/review\/)?([0-9]+).*
        |(?:\/\w*\/))|(?:video\/))?([0-9]+).*$
        /x
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
