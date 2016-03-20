require 'json'
require 'open-uri'

class VideoInfo
  module Providers
    class Facebook < Provider
      def self.usable?(url)
        url =~ %r{(facebook\.com\/.*/videos/.*)|
                  (facebook\.com/.*\%2Fvideos%2F)|
                  (facebook.com\/story.php\?story_fbid=.*)}x
      end

      def author
        data['from']['name']
      end

      def author_thumbnail
        data['author_thumbnail']['url']
      end

      def author_url
        'https://www.facebook.com/' + data['from']['id']
      end

      def date
        created_at = data['created_time']
        Time.parse(created_at, Time.now.utc)
      end

      def description
        data['description']
      end

      def duration
        data['length'].round.to_i
      end

      def thumbnail
        data['picture']
      end

      def thumbnail_small
        nil
      end

      def thumbnail_medium
        nil
      end

      def thumbnail_large
        nil
      end

      def title
        data['title']
      end

      def width
        nil
      end

      def height
        nil
      end

      private

      def available?
        true
      end

      def _url_regex
        %r{(?:.*facebook\.com\/.*\/videos\/(.*)/)|
           (?:.*facebook\.com\/story.php\?story_fbid\=(.*)\&id)}x
      end

      def _api_base
        'graph.facebook.com'
      end

      def _api_version
        'v2.5'
      end

      def _api_path
        "/#{_api_version}/#{video_id}" \
        '?fields=created_time,description,from,length,picture,title' \
        "&access_token=#{_access_token}"
      end

      def _api_url
        "https://#{_api_base}#{_api_path}"
      end

      def _profile_api_path(user_id)
        "/#{_api_version}/#{user_id}/picture" \
        "?redirect=0&access_token=#{_access_token}"
      end

      def _profile_api_url(user_id)
        "https://#{_api_base}#{_profile_api_path(user_id)}"
      end

      def _access_token
        VideoInfo.provider_api_keys[:facebook_access_token]
      end

      def _set_data_from_api_impl(api_url)
        encoded_api_url = URI.encode(api_url)

        data = super(encoded_api_url)

        user_id = data['from']['id']

        encoded_profile_api_url = URI.encode(_profile_api_url(user_id))

        author_thumbnail_data = super(encoded_profile_api_url)['data']

        data = data.merge('author_thumbnail' => author_thumbnail_data)

        data.freeze
      end
    end
  end
end
