# encoding: UTF-8

require 'open-uri'
require 'multi_json'
require 'htmlentities'

if RUBY_VERSION.to_i < 2
  require 'iconv'
end

module VideoInfo
  module Providers
    class Vkontakte < Provider
      attr_accessor :video_owner

      def self.usable?(url)
        url =~ /(vk\.com)|(vkontakte\.ru)/
      end

      def provider
        'Vkontakte'
      end

      %w[description keywords].each do |method|
        define_method(method) { HTMLEntities.new.decode(video[:description]) }
      end

      %w[width height duration view_count].each do |method|
        define_method(method) { video[method.to_sym].to_i }
      end

      def title
        video[:title]
      end

      def embed_url
        "http://vk.com/video_ext.php?oid=#{video_owner}&id=#{video_id}&hash=#{video[:hash]}"
      end

      private

      def _parse_hash
        @html[/hash2\\":\\"(\w+)/,1]
      end

      def _parse_view_count
        @html[/mv_num_views\\"><b>(\d+)/,1].to_i
      end

      def _parse_title
        @html[/<title>(.*)<\/title>/,1].gsub(" | ВКонтакте", "")
      end

      def _parse_duration
        @html[/"duration":(\d+)/,1].to_i
      end

      def _parse_height
        @html[/url(\d+)/,1].to_i
      end

      def _get_width(height)
        { 240 => 320,
          360 => 480,
          480 => 640,
          720 => 1280
        }[height]
      end

      def _parse_description
        @html[/<meta name="description" content="(.*)" \/>/,1]
      end

      def _set_info_from_api
        uri = open(_api_url, options)
        if RUBY_VERSION.to_i < 2
          @html = Iconv.iconv('utf-8', 'cp1251', uri.read)[0]
        else
          @html = uri.read.encode("UTF-8")
        end
        @video = {
          :hash => _parse_hash,
          :view_count => _parse_view_count,
          :title => _parse_title,
          :duration => _parse_duration,
          :width => _get_width(_parse_height),
          :height => _parse_height,
          :description => _parse_description
        }
      end

      def _set_video_id_from_url
        url.gsub(_url_regex) { @video_owner, @video_id = ($1 || $2 || $3).split('_') }
      end

      def _url_regex
        /(?:vkontakte\.ru\/video|vk\.com\/video)(\d+_\d+)/i
      end

      def _api_url
        "http://vk.com/video#{video_owner}_#{video_id}"
      end

      def _default_iframe_attributes
        { :allowfullscreen => "allowfullscreen" }
      end

      def _default_url_attributes
        {}
      end

    end
  end
end
