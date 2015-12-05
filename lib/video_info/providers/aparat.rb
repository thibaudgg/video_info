class VideoInfo
  module Providers
    class Aparat < Provider
      def self.usable?(url)
        url =~ /((.*)aparat\.com\/v\/(.*))/
      end

      def provider
        'Aparat'
      end

      def api_key
        ""
      end

      %w[description].each do |method|
        define_method(method) { _video[method] }
      end

      %w[duration width height].each do |method|
        define_method(method) { _video[method].to_i }
      end

      def title
        _video['title']
      end

      def author
        _video['username']
      end

      def author_thumbnail_id
        author_uri = _video['username']
        @author_thumbnail_id ||= _parse_picture_id(author_uri)
      end

      def author_thumbnail(width = 75)
        _video['profilePhoto']
      end

      def thumbnail_id
        @thumbnail_id = "123"
      end

      def thumbnail(width = 200, height = nil)
      return _video['big_poster']
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

      def embed_url
        "http://www.aparat.com/video/video/embed/videohash/#{_video['uid']}/vt/frame/"
      end

      def date
        Time.now
      end

      def view_count
        _video['visit_cnt'].to_i
      end

      private

      def _clean_options(options)
        headers = [super, _authorization_headers, _api_version_headers]
        headers.inject(&:merge)
      end

      def _api_version
        '3.2'
      end

      def _authorization_headers
        { 'Authorization' => "bearer #{api_key}" }
      end

      def _api_version_headers
        { 'Accept' => "application/vnd.aparat.*+json;version=#{_api_version}" }
      end

      def _video
        data
      end

      def _url_regex
        /^http[s]?:\/\/www.aparat.com\/v\/(.+)/
      end

      def _api_base
        'www.aparat.com/etc/api'
      end

      def _api_path
      
        "/video/videohash/#{video_id}"
      end

      def _api_url
        "http://#{_api_base}#{_api_path}"
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

      def _parse_picture_id(uri)
        /\/pictures\/(\d+)/.match(uri)[1]
      end
    end
  end
end
