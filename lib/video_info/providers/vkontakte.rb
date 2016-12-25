# encoding: utf-8
require 'cgi'
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
        vkontakte = !!(url =~ %r{\A(http|https):\/\/(vk\.com)|
                                 (vkontakte\.ru)\z})
        valid = !!(url =~ /\A#{URI.regexp(%w[http https])}\z/)
        vkontakte && valid
      end

      def provider
        'Vkontakte'
      end

      def description
        content = data[/"desc":"(.*?)",/, 1]
        CGI.unescape_html(content).gsub('&nbsp;', ' ')
      end

      def keywords
        nil
      end

      def width
        data[/PLAYER_FULL_WIDTH":(\d+)/, 1].to_i
      end

      def height
        data[/PLAYER_FULL_HEIGHT":(\d+)/, 1].to_i
      end

      def author
        data_after_author_div = data.split('<a class="mem_link" href="')[1]
        data_after_author_div.split('</a>')[0].split('">')[1]
      end

      def author_thumbnail
        split_point = '<img id="mv_author_photo" class="mv_author_photo" src="'
        get_between(split_point, '">')
      end

      def author_url
        split_point = "<div class=\"mv_author_name\">\n          <a class=\"mem_link\" href=\""
        'https://vk.com' + get_between(split_point, '">')
      end

      def title
        data[%r{\="mv_title">(.*)<\/div>}, 1].gsub(' | ВКонтакте', '')
      end

      def view_count
        data[/mv_views_count.*?(\d+)/, 1].to_i
      end

      def embed_url
        iframe_src = data[
          /iframe\ id=\"video_yt_player\".*src=\"([^\"]*)\".*frameborder=/, 1
        ]
        if iframe_src
          # it may be youtube video
          VideoInfo::Providers::Youtube.new(
            URI.unescape(iframe_src.delete(/\\/, ''))
          ).embed_url
        else
          "//vk.com/video_ext.php?oid=#{video_owner}" \
          "&id=#{video_id}&hash=#{_data_hash}"
        end
      rescue
        # or rutube video
        iframe_src
      end

      def duration
        data[/"duration":(\d+)/, 1].to_i
      end

      def available?
        !%w[403 404 302 401].include?(_response_code) &&
          !(data =~ /(Ошибка доступа|Access denied)/)
      end

      def thumbnail_small
        thumb = data[/"thumb":"(.*?)"/, 1]
        return thumb.delete('\\') unless thumb.nil?
        nil
      end

      def thumbnail_medium
        thumbnail_small
      end

      def thumbnail_large
        nil
      end

      def thumbnail_maxres
        nil
      end

      private

      def _make_request(url, options)
        request = Net::HTTP::Post.new(url.path)
        request.add_field 'User-Agent', 'Mozilla/5.0 (Linux; VideoInfo)'
        request.body = URI.encode_www_form(options)
        conn = Net::HTTP.new(url.host, url.port)
        conn.use_ssl = true
        resp = conn.request(request)
        resp.body.force_encoding('cp1251').encode('UTF-8', undef: :replace)
      end

      def _set_data_from_api_impl(api_url)
        options['act'] = 'show'
        options['al'] = '1'
        options['autoplay'] = '0'
        options['module'] = 'profile'
        options['video'] = "#{@video_owner}_#{@video_id}"
        data = _make_request(api_url, options)
        if data.index('Ошибка доступа')
          # try second time
          _make_request(api_url, options)
        else
          data
        end
      end

      def _error_found?(response)
        title = response.body[
          %r{<title>(.*)<\/title>}, 1
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
        check_url = URI.parse(url)
        req = Net::HTTP::Get.new(check_url)
        req.add_field('User-Agent', 'Mozilla/5.0 (Linux; VideoInfo)')
        res = Net::HTTP.start(check_url.host, check_url.port) do |http|
          http.request(req)
        end
        return res.code unless res.code == '302' && !res['location'].nil?
        self.url = res['location']
        _response_code
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
        %r{(?:vkontakte\.ru\/video|vk\.com\/video
            |vk\.com\/.*?video)(-?\d+_\d+)}i
      end

      def _default_iframe_attributes
        { allowfullscreen: 'allowfullscreen' }
      end

      def _default_url_attributes
        {}
      end

      def _api_url
        URI('https://vk.com/al_video.php')
      end

      def get_between(from_here, to_here)
        data.split(from_here)[1].split(to_here)[0]
      end
    end
  end
end
