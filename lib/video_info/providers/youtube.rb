require "iso8601"
require_relative "youtube_api"
require_relative "youtube_scraper"

class VideoInfo
  module Providers
    class Youtube < Provider
      def initialize(url, options = {})
        if VideoInfo.provider_api_keys[:youtube].nil?
          extend YoutubeScraper
        else
          extend YoutubeAPI
        end

        super(url, options)
      end

      def self.usable?(url)
        url.match?(/(youtube\.com\/(?!playlist|embed\/videoseries).*)|(youtu\.be)/)
      end

      def provider
        "YouTube"
      end

      %w[width height].each do |method|
        define_method(method) { nil }
      end

      def embed_url
        "//www.youtube.com/embed/#{video_id}"
      end

      def thumbnail_small
        "https://i.ytimg.com/vi/#{video_id}/default.jpg"
      end

      def thumbnail_medium
        "https://i.ytimg.com/vi/#{video_id}/mqdefault.jpg"
      end

      def thumbnail_large
        "https://i.ytimg.com/vi/#{video_id}/hqdefault.jpg"
      end

      def thumbnail_large_2x
        "https://i.ytimg.com/vi/#{video_id}/sddefault.jpg"
      end

      def thumbnail_maxres
        "https://i.ytimg.com/vi/#{video_id}/maxresdefault.jpg"
      end

      private

      def _url_regex
        %r{(?:youtube(?:-nocookie)?\.com/(?:[^/]+/.+/|(?:v|e(?:mbed)?|live|shorts)/|
           .*[?&]v=)|youtu\.be/)([^"&?/ ]{11})}x
      end

      def _default_iframe_attributes
        {allowfullscreen: "allowfullscreen"}
      end

      def _default_url_attributes
        {}
      end

      def resize_thumb(url, size)
        url.gsub(/(https:\/\/yt3.ggpht.com\/.*\/.*=s)([0-9]*)(.*)/, "\\1#{size}\\3")
      end
    end
  end
end
