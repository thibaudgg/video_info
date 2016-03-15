require 'open-uri'
require 'oga'

class VideoInfo
  module Providers
    class Facebook < Provider
      def self.usable?(url)
        url =~ %r{(facebook\.com\/.*/videos/.*)|
                  (facebook\.com/.*\%2Fvideos%2F)}x
      end

      def author
        data.css('#fbPhotoPageAuthorName')[0].text
      end

      def author_thumbnail
        data.css('#fbPhotoPageAuthorPic')[0].css('img')[0].attr('src').value
      end

      private

      def available?
        true
      end

      def _url_regex
        %r{(?:.*facebook\.com\/.*\/videos\/(.*)/)}
      end

      def _set_data_from_api_impl(api_url)
        html = open(api_url).read

        Oga.parse_html(html.force_encoding('UTF-8'))
      end

      def _api_url
        uri = URI.parse(@url)

        unless uri.scheme
          uri.path = uri.path.prepend('//')
        end

        uri.scheme = 'https'

        uri.to_s
      end
    end
  end
end
