# encoding: UTF-8
require 'htmlentities'
require 'iconv' if RUBY_VERSION.to_i < 2

class VideoInfo
  module Providers
    class Vkontakte < Provider
      attr_accessor :video_owner

      def self.usable?(url)
        url =~ /(vk\.com)|(vkontakte\.ru)/
      end

      def provider
        'Vkontakte'
      end

      def description
        content = data[/<meta name="description" content="(.*)" \/>/,1]
        HTMLEntities.new.decode(content)
      end
      alias_method :keywords, :description

      def width
        { 240 => 320,
          360 => 480,
          480 => 640,
          720 => 1280
        }[height]
      end

      def height
        data[/url(\d+)/,1].to_i
      end

      def title
        data[/<title>(.*)<\/title>/,1].gsub(" | ВКонтакте", "")
      end

      def view_count
        data[/mv_num_views\\">.*?(\d+)/,1].to_i
      end

      def embed_url
        "//vk.com/video_ext.php?oid=#{video_owner}&id=#{video_id}&hash=#{_data_hash}"
      end

      def duration
        data[/"duration":(\d+)/,1].to_i
      end

      private

      def _set_data_from_api
        uri = open(url, options)
        if RUBY_VERSION.to_i < 2
          Iconv.iconv('utf-8', 'cp1251', uri.read)[0]
        else
          uri.read.encode("UTF-8")
        end
      end

      def _response_code
        response = nil
        Net::HTTP.start(_api_base, 80) {|http|
          response = http.get(_api_path)
        }
        response.code
      end

      def _api_base
        URI::parse(url).host
      end

      def _api_path
        URI::parse(url).path
      end

      def _data_hash
        data[/hash2\\":\\"(\w+)/,1]
      end

      def _set_video_id_from_url
        url.gsub(_url_regex) { @video_owner, @video_id = $1.split('_') }
      end

      def _url_regex
        /(?:vkontakte\.ru\/video|vk\.com\/video)(-?\d+_\d+)/i
      end

      def _default_iframe_attributes
        { allowfullscreen: "allowfullscreen" }
      end

      def _default_url_attributes
        {}
      end

    end
  end
end
