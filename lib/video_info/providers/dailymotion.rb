class VideoInfo
  module Providers
    class Dailymotion < Provider
      def self.usable?(url)
        url.match?(/(dai(?:\.ly|lymotion\.com))/)
      end

      def provider
        "Dailymotion"
      end

      %w[title description duration].each do |method|
        define_method(method) { data[method] }
      end

      %w[width height].each do |method|
        define_method(method) { nil }
      end

      def author
        data["owner.screenname"]
      end

      def author_url
        data["owner.url"]
      end

      def author_thumbnail
        data["owner.avatar_60_url"]
      end

      def keywords
        data["tags"]
      end

      def embed_url
        "//www.dailymotion.com/embed/video/#{video_id}"
      end

      def date
        Time.at(data["created_time"]).utc
      end

      def thumbnail_small
        data["thumbnail_60_url"]
      end

      def thumbnail_medium
        data["thumbnail_240_url"]
      end

      def thumbnail_large
        data["thumbnail_720_url"]
      end

      def view_count
        data["views_total"].to_i
      end

      def stats
        {
          "views_total" => view_count,
          "likes_total" => data["likes_total"].to_i
        }
      end

      private

      def _response_code
        response = nil
        Net::HTTP.start(_api_base, 443, use_ssl: true) do |http|
          response = http.get(_api_path)
        end
        response.code
      end

      def _url_regex
        %r{dai(?:\.ly|lymotion\.com/(?:embed/)?video)/([a-zA-Z0-9]*)}
      end

      def _api_base
        "api.dailymotion.com"
      end

      def _api_path
        "/video/#{video_id}"
      end

      def _api_url
        "https://#{_api_base}#{_api_path}?" \
        "fields=id,title,description,duration,created_time," \
        "url,views_total,tags,thumbnail_url,thumbnail_720_url," \
        "owner.url,owner.screenname,owner.avatar_60_url," \
        "thumbnail_240_url,thumbnail_60_url,likes_total"
      end

      def _default_iframe_attributes
        {}
      end

      def _default_url_attributes
        {autoplay: 0}
      end
    end
  end
end
