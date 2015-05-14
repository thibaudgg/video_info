# encoding: UTF-8
require 'htmlentities'
require 'net/http'

class VideoInfo
  module Providers
    class Vkontakte < Provider
      attr_accessor :video_owner

      def initialize(url, options = {})
        super(url, options)
        @url.strip!
      end

      def self.usable?(url)
        url.strip!
        vkontakte = !!(url =~ /\A(http|https):\/\/(vk\.com)|(vkontakte\.ru)\z/)
        valid = !!(url =~ /\A#{URI::regexp(['http', 'https'])}\z/)
        vkontakte && valid
      end

      def provider
        'Vkontakte'
      end

      def description
        content = data[/"desc":"(.*?)",/, 1]
        HTMLEntities.new.decode(content)
      end
      alias_method :keywords, :description

      def width
        { 240 => 320,
          360 => 480,
          480 => 640,
          720 => 1280
        }[height].to_i
      end

      def height
        data[/url(\d+)/,1].to_i
      end

      def title
        data[/\="mv_title">(.*)<\/div>/, 1].gsub(' | ВКонтакте', '')
      end

      def view_count
        data[/mv_views_count_number\">.*?(\d+)/, 1].to_i
      end

      def embed_url
        youtube = data[
          /iframe\ id=\"video_player\".*src=\"(.*)\"\ frameborder=/, 1
        ]
        if youtube
          VideoInfo::Providers::Youtube.new(
            URI.unescape(youtube.gsub(/\\/, ''))
          ).embed_url
        else
          "//vk.com/video_ext.php?oid=#{video_owner}" +
            "&id=#{video_id}&hash=#{_data_hash}"
        end
      end

      def duration
        data[/"duration":(\d+)/, 1].to_i
      end

      def available?
        !%w[403 404 302 401].include?(_response_code)
      end

      private

      def _make_request(url, options)
        request = Net::HTTP::Post.new(url.path)
        request.body = URI.encode_www_form(options)
        conn = Net::HTTP.new(url.host, url.port)
        conn.use_ssl = true
        resp = conn.request(request)
        resp.body.force_encoding('cp1251').encode('UTF-8', undef: :replace)
      end

      def _set_data_from_api
        url = URI('https://vk.com/al_video.php')
        options['act'] = 'show'
        options['al'] = '1'
        options['video'] = "#{@video_owner}_#{@video_id}"
        data = _make_request(url, options)
        if data.index('Ошибка доступа')
          # try second time
          _make_request(url, options)
        else
          data
        end
      end

      def _error_found?(response)
        title = response.body[
          /<title>(.*)<\/title>/, 1
        ].force_encoding(
          'cp1251'
        ).encode(
          'UTF-8', undef: :replace
        )
        !!title.index('Error | VK')
      end

      def _get_response_code(response)
        if response.header['location'] == '/'
          '401'
        elsif response.code == '302'
          '302'
        elsif _error_found? response
          '403'
        else
          response.code
        end
      end

      def _response_code
        response = Net::HTTP.get_response(_api_base, _api_path, 80)
        code = _get_response_code response
        if code == '302'
          _get_response_code Net::HTTP.get_response(
            URI.parse(response.header['location'])
          )
        else
          code
        end
      end

      def _api_base
        URI.parse(url).host
      end

      def _api_path
        URI.parse(url).path
      end

      def _data_hash
        data[/"hash2":"(\w+)/, 1]
      end

      def _set_video_id_from_url
        url.gsub(_url_regex) { @video_owner, @video_id = $1.split('_') }
      end

      def _url_regex
        /(?:vkontakte\.ru\/video|vk\.com\/video|vk\.com\/.*?video)(-?\d+_\d+)/i
      end

      def _default_iframe_attributes
        { allowfullscreen: 'allowfullscreen' }
      end

      def _default_url_attributes
        {}
      end
    end
  end
end
