class VideoInfo
  module Providers
    module VimeoAPI
      THUMBNAIL_LINK_REGEX = /.*\/(\d+-[^_]+)/

      def api_key
        VideoInfo.provider_api_keys[:vimeo]
      end

      def available?
        is_available = super

        if is_available
          # For password-protected videos, the API might return 200 on HEAD
          # but fail or return incomplete data on GET. Try to access the video data.
          begin
            video_data = _video
            # Check if we have the essential video data
            is_available = !video_data.nil? && !video_data["name"].nil?
          rescue VideoInfo::HttpError
            # If we get an HTTP error (like 401), the video is not available
            is_available = false
          end
        end

        is_available
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

      def embed_url
        _video["player_embed_url"]
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
