require 'open-uri'
require 'multi_json'

module VideoInfo
  module Providers
    class Youtube < Provider

      def self.usable?(url)
        url =~ /(youtube\.com)|(youtu\.be)/
      end

      private

      def _url_regex
        /youtube\.com\/.*\?v=([A-Za-z0-9._%-]*)?|youtu\.be\/([A-Za-z0-9._%-]*)?|youtube\.com\/embed\/([A-Za-z0-9._%-]*)?/
      end

      def _set_info_from_api
        uri   = open("http://gdata.youtube.com/feeds/api/videos/#{video_id}?v=2&alt=json", options)
        video = MultiJson.load(uri.read)
        @provider         = "YouTube"
        @url              = url
        @embed_url        = "http://www.youtube.com/embed/#{video_id}"
        @embed_code       = "<iframe src=\"#{embed_url}\" frameborder=\"0\" allowfullscreen=\"allowfullscreen\"#{iframe_attributes}></iframe>"
        video['entry'].tap do |entry|
          @title            = entry['title']['$t']
          @description      = entry['media$group']['media$description']['$t']
          @keywords         = entry['media$group']['media$keywords']['$t']
          @duration         = entry['media$group']['yt$duration']['seconds'].to_i
          @date             = Time.parse(entry['published']['$t'], Time.now.utc)
          @thumbnail_small  = entry['media$group']['media$thumbnail'][0]['url']
          @thumbnail_medium = entry['media$group']['media$thumbnail'][1]['url']
          @thumbnail_large  = entry['media$group']['media$thumbnail'][2]['url']
          @view_count = entry['yt$statistics'] ? entry['yt$statistics']['viewCount'].to_i : 0
        end
      rescue
        nil
      end

    end
  end
end
