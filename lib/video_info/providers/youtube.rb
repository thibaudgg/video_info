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
        VideoInfo.provider_api_keys[:youtube]
      end

      def title
        _video_snippet['title']
      end

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
        video_duration = _video_content_details['duration'] || 0
        ISO8601::Duration.new(video_duration).to_seconds.to_i
      end

      def embed_url
        "//www.youtube.com/embed/#{video_id}"
      end

      def date
        return unless published_at = _video_snippet['publishedAt']
        Time.parse(published_at, Time.now.utc)
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

      def view_count
        _video_statistics['viewCount'].to_i rescue 0
      end

      def author
        _video_snippet['channelTitle']
      end

      def author_thumbnail
        _channel_snippet["items"][0]["snippet"]["thumbnails"]
        ["default"]["url"] rescue nil
      end

      private

      def available?
        data['items'].size > 0 rescue false
      end

      def _url_regex
        /(?:youtube(?:-nocookie)?\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/ ]{11})/i
      end

      def _api_base
        'www.googleapis.com'
      end

      def _channel_api_url(channel_id)
        "https://#{_api_base}/youtube/v3/channels?part=snippet&id
        =#{channel_id}&key=#{api_key}"
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

      def _channel_snippet
        channel_url = _channel_api_url(_video_snippet['channelId'])
        @channel_data ||= open(channel_url)
        MultiJson.load(@channel_data.read)
      end

      def _video_snippet
        return {} unless available?
        data['items'][0]['snippet']
      end

      def _video_content_details
        return {} unless available?
        data['items'][0]['contentDetails']
      end

      def _video_statistics
        return {} unless available?
        data['items'][0]['statistics']
      end

      def _video_thumbnail(id)
        _video_entry['media$group']['media$thumbnail'][id]['url']
      end
    end
  end
end
