require 'oga'
require 'open-uri'
require 'net_http_timeout_errors'

class VideoInfo
  module Providers
    module YoutubeScraper
      BASE_URL = "https://www.youtube.com"
      CHANNEL_URL = "#{BASE_URL}/channel/"
      THUMB_DEFAULT_SIZE = 88

      def available?
        !!title
      end

      def date
        date = itemprop_node_value('datePublished')

        Time.parse(date) if date
      end

      def author
        meta_node_value(channel_meta_nodes, 'og:title')
      end

      def author_thumbnail
        image_hq_url = meta_node_value(channel_meta_nodes, 'og:image')

        resize_thumb(image_hq_url, THUMB_DEFAULT_SIZE)
      end

      def channel_id
        itemprop_node_value('channelId')
      end

      def author_url
        URI.join(CHANNEL_URL, channel_id).to_s
      end

      def description
        meta_node_value(video_meta_nodes, 'og:description')
      end

      def duration
        duration = itemprop_node_value('duration')

        if duration
          ISO8601::Duration.new(duration).to_seconds.to_i
        else
          0
        end
      end

      def keywords
        return unless available?

        value = meta_node_value(video_meta_nodes, 'keywords')

        value.split(', ') if value
      end

      def title
        return if meta_node_value('title').empty?
        meta_node_value('title')
      end

      def view_count
        itemprop_node_value('interactionCount').to_i
      end

      private

      def video_meta_nodes
        @video_meta_nodes ||= data.css('meta')
      end

      def channel_meta_nodes
        @channel_meta_nodes ||= channel_data.css('meta')
      end

      def channel_data
        @channel_data ||= Oga.parse_html(URI.open(author_url).read)
      end

      def meta_node_value(meta_nodes=video_meta_nodes, name)
        node = meta_nodes.detect do |n|
          n.attr('name')&.value == name || n.attr('property')&.value == name
        end

        return unless node
        node && node.attr('content') && node.attr('content').value
      end

      def itemprop_node_value(name)
        node = video_meta_nodes.detect do |m|
          itemprop_attr = m.attr('itemprop')

          itemprop_attr.value == name if itemprop_attr
        end

        return unless node
        node.attr('content').value
      end

      def _set_data_from_api_impl(api_url)
        # handle fullscreen video URLs
        if url.include?('.com/v/')
          video_id = url.split('/v/')[1].split('?')[0]
          new_url = 'https://www.youtube.com/watch?v=' + video_id
          Oga.parse_html(URI.open(new_url).read)
        else
          Oga.parse_html(URI.open(api_url).read)
        end
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
