class VideoInfo
  module Providers
    module VimeoAPI
      THUMBNAIL_LINK_REGEX = /.*\/(\d+-[^_]+)/

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
        _video["name"]
      end

      def author
        _video["user"]["name"]
      end

      def author_thumbnail_id
        author_uri = _video["user"]["pictures"]["uri"]
        @author_thumbnail_id ||= parse_picture_id_from_user(author_uri)
      end

      def author_url
        _video["user"]["link"]
      end

      def author_thumbnail(width = 75)
        "https://i.vimeocdn.com/portrait/" \
        "#{author_thumbnail_id}_#{width}x#{width}.jpg"
      end

      def thumbnail_id
        @thumbnail_id ||= parse_picture_id(_video.dig("pictures", "sizes").first["link"])
      end

      def thumbnail_small
        generate_thumbnail(100, 75)
      end

      def thumbnail_medium
        generate_thumbnail(200, 150)
      end

      def thumbnail_large
        generate_thumbnail(640)
      end

      def keywords
        keywords_array
      end

      def keywords_array
        _video["tags"].map { |t| t["tag"] }
      end

      def date
        Time.parse(_video["created_time"], Time.now.utc).utc
      end

      def view_count
        stats["plays"].to_i
      end

      def stats
        _video["stats"]
      end

      private

      def generate_thumbnail(width = 200, height = nil)
        base_uri = "https://i.vimeocdn.com/video/#{thumbnail_id}"
        if height
          base_uri + "_#{width}x#{height}.jpg"
        else
          base_uri + "_#{width}.jpg"
        end
      end

      def _clean_options(options)
        headers = [super, _authorization_headers, _api_version_headers]
        headers.inject(&:merge)
      end

      def _api_version
        "3.2"
      end

      def _authorization_headers
        {"Authorization" => "bearer #{api_key}"}
      end

      def _api_version_headers
        {"Accept" => "application/vnd.vimeo.*+json;version=#{_api_version}"}
      end

      def _video
        data
      end

      def _api_base
        "api.vimeo.com"
      end

      def _api_path
        "/videos/#{video_id}"
      end

      def _api_url
        "https://#{_api_base}#{_api_path}"
      end

      def parse_picture_id_from_user(uri)
        %r{/pictures/(\d+)}.match(uri)[1]
      end

      def parse_picture_id(uri)
        uri.match(THUMBNAIL_LINK_REGEX)[1]
      end
    end
  end
end
