require 'iso8601'
class VideoInfo
  module Providers
    class Youtube < Provider
      def self.usable?(url)
        url =~ /(youtube\.com\/(?!playlist|embed\/videoseries).*)|(youtu\.be)/
      end

      def provider
        'YouTube'
      end

      def api_key
        VideoInfo.providers_api_key[:youtube]
      end

      def title
        _video_snippet['title']
      end

      # %w[description keywords].each do |method|
      #   define_method(method) { _video_entry["media$#{method}"]['$t'] }
      # end

      def description
        _video_snippet['description']
      end

      def keywords
        _video_snippet['tags']
      end

      %w[width height].each do |method|
        define_method(method) { nil }
      end

      def duration
         ISO8601::Duration.new(_video_content_details['duration']).to_seconds.to_i
      end

      def embed_url
        "//www.youtube.com/embed/#{video_id}"
      end

      def date
        Time.parse(_video_snippet['publishedAt'], Time.now.utc)
      end

      def thumbnail_small
        _video_snippet['thumbnails']['default']['url']
      end

      def thumbnail_medium
        _video_snippet['thumbnails']['medium']['url']
      end

      def thumbnail_large
        _video_snippet['thumbnails']['high']['url']
      end

      def view_count
        _video_statistics['viewCount'].to_i rescue 0
      end

      private

      def _url_regex
        /(?:youtube(?:-nocookie)?\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/ ]{11})/i
      end

      def _api_base
        "www.googleapis.com"
      end

      def _api_path
        "/youtube/v3/videos?id=#{video_id}&part=snippet,statistics,contentDetails&fields=items(id,snippet,statistics,contentDetails)&key=#{api_key}"
      end

      def _api_url
        "https://#{_api_base}#{_api_path}"
      end

      def _default_iframe_attributes
        { allowfullscreen: 'allowfullscreen' }
      end

      def _default_url_attributes
        {}
      end

      def _video_snippet
        data['items'][0]['snippet']
      end

      def _video_content_details
        data['items'][0]['contentDetails']
      end

      def _video_statistics
        data['items'][0]['statistics']
      end

      # def _video_media_group
      #   data['entry']['media$group']
      # end

      def _video_thumbnail(id)
        _video_entry['media$group']['media$thumbnail'][id]['url']
      end
    end
  end
end
