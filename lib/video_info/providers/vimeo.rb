require 'open-uri'
require 'multi_json'

module VideoInfo
  module Providers
    class Vimeo < Provider

      def self.usable?(url)
        url =~ /vimeo\.com/
      end

      def default_iframe_attributes
        {}
      end

      def default_url_attributes
        { :title => 0,
          :byline => 0,
          :portrait => 0,
          :autoplay => 0 }
      end

      private

      def _url_regex
        /vimeo\.com\/(?:(?:groups\/[^\/]+\/videos\/)|(?:video\/))?([0-9]+).*$/i
      end

      def _set_info_from_api
        uri   = open("http://vimeo.com/api/v2/video/#{video_id}.json", options)
        video = MultiJson.load(uri.read).first

        @provider         = "Vimeo"
        @url              = video['url']
        @embed_url        = "player.vimeo.com/video/#{video_id}"
        @title            = video['title']
        @description      = video['description']
        @keywords         = video['tags']
        @duration         = video['duration'].to_i # seconds
        @width            = video['width'].to_i
        @height           = video['height'].to_i
        @date             = Time.parse(video['upload_date'], Time.now.utc).utc
        @thumbnail_small  = video['thumbnail_small']
        @thumbnail_medium = video['thumbnail_medium']
        @thumbnail_large  = video['thumbnail_large']
        @view_count       = video['stats_number_of_plays'].to_i
      rescue
        nil
      end

    end
  end
end
