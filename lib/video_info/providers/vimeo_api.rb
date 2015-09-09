class VideoInfo
  module Providers
    module VimeoAPI
      def api_key
        VideoInfo.provider_api_keys[:vimeo]
      end

      %w[description].each do |method|
        define_method(method) { _video[method] }
      end

      %w[duration width height].each do |method|
        define_method(method) { _video[method].to_i }
      end

      def title
        _video['name']
      end

      def author
        _video['user']['name']
      end

      def author_thumbnail_id
        author_uri = _video['user']['pictures']['uri']
        @author_thumbnail_id ||= _parse_picture_id(author_uri)
      end

      def author_thumbnail(width = 75)
        "https://i.vimeocdn.com/portrait/#{author_thumbnail_id}_#{width}x#{width}.jpg"
      end

      def thumbnail_id
        @thumbnail_id ||= _parse_picture_id(_video['pictures']['uri'])
      end

      def thumbnail(width = 200, height = nil)
        base_uri = "https://i.vimeocdn.com/video/#{thumbnail_id}"
        height ? base_uri + "_#{width}x#{height}.jpg" : base_uri + "_#{width}.jpg"
      end

      def thumbnail_small
        thumbnail(100, 75)
      end

      def thumbnail_medium
        thumbnail(200, 150)
      end

      def thumbnail_large
        thumbnail(640)
      end

      def keywords
        keywords_array.join(', ')
      end

      def keywords_array
        _video['tags'].map { |t| t['tag'] }
      end

      def date
        Time.parse(_video['created_time'], Time.now.utc).utc
      end

      def view_count
        _video['stats']['plays'].to_i
      end
    end
  end
end
