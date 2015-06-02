require 'iso8601'
require_relative 'youtube_api'
require_relative 'youtube_scraper'

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
        url =~ /(youtube\.com\/(?!playlist|embed\/videoseries).*)|(youtu\.be)/
      end

      def provider
        'YouTube'
      end

      %w[width height].each do |method|
        define_method(method) { nil }
      end

      def embed_url
        "//www.youtube.com/embed/#{video_id}"
      end

      def thumbnail_small
        return "https://i.ytimg.com/vi/#{video_id}/default.jpg" unless _video_snippet['thumbnails']
        _video_snippet['thumbnails']['default']['url']
      end

      def thumbnail_medium
        return "https://i.ytimg.com/vi/#{video_id}/mqdefault.jpg" unless _video_snippet['thumbnails']
        _video_snippet['thumbnails']['medium']['url']
      end

      def thumbnail_large
        return "https://i.ytimg.com/vi/#{video_id}/hqdefault.jpg" unless _video_snippet['thumbnails']
        _video_snippet['thumbnails']['high']['url']
      end

      private

      def _url_regex
        /(?:youtube(?:-nocookie)?\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/ ]{11})/i
      end

      def _default_iframe_attributes
        { allowfullscreen: 'allowfullscreen' }
      end

      def _default_url_attributes
        {}
      end
    end
  end
end
