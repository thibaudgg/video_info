class VideoInfo
  module Providers
    module YoutubeAPI
      def api_key
        VideoInfo.provider_api_keys[:youtube]
      end

      def author
        _video_snippet['channelTitle']
      end

      def author_thumbnail
        _channel_snippet['thumbnails']['default']['url']
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

      def duration
        video_duration = _video_content_details['duration'] || 0
        ISO8601::Duration.new(video_duration).to_seconds.to_i
      end

      def date
        return unless published_at = _video_snippet['publishedAt']
        Time.parse(published_at, Time.now.utc)
      end

      def view_count
        _video_statistics['viewCount'].to_i
      end

      private

      def available?
        !data['items'].empty?
      rescue VideoInfo::HttpError
        false
      end

      def _api_base
        'www.googleapis.com'
      end

      def _api_path
        "/youtube/v3/videos?id=#{video_id}" \
        '&part=snippet,statistics,contentDetails&fields=' \
        "items(id,snippet,statistics,contentDetails)&key=#{api_key}"
      end

      def _api_url
        "https://#{_api_base}#{_api_path}"
      end

      def _video_snippet
        return {} unless available?
        data['items'][0]['snippet']
      end

      def _channel_api_url(channel_id)
        "https://#{_api_base}/youtube/v3/channels?part=snippet&id" \
        "=#{channel_id}&key=#{api_key}"
      end

      def _channel_snippet
        channel_url = _channel_api_url(_video_snippet['channelId'])
        @channel_data ||= open(channel_url)
        json_data = JSON.load(@channel_data.read)
        json_data['items'][0]['snippet']
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
