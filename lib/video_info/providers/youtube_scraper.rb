require "oga"
require "net_http_timeout_errors"

class VideoInfo
  module Providers
    module YoutubeScraper
      BASE_URL = "https://www.youtube.com"
      CHANNEL_URL = "#{BASE_URL}/channel/"
      THUMB_DEFAULT_SIZE = 88
      DEFAULT_YOUTUBE_DESCRIPTION = "Enjoy the videos and music you love, upload original content, and share it all with friends, family, and the world on YouTube."

      def available?
        !!title
      end

      def date
        date = itemprop_node_value("datePublished")

        Time.parse(date) if date
      end

      def author
        meta_node_value(channel_meta_nodes, "og:title")
      end

      def author_thumbnail
        image_hq_url = meta_node_value(channel_meta_nodes, "og:image")

        resize_thumb(image_hq_url, THUMB_DEFAULT_SIZE)
      end

      def channel_id
        # NOTE the previous implementation, based on itemprop_node_value("channelId"),
        # does not work well, probably due to some YouTube change
        page_content = data.to_s
        matches = page_content.match(/"channelId":"([a-zA-Z0-9_-]+)"/)
        matches[1] if matches
      end

      def author_url
        URI.join(CHANNEL_URL, channel_id).to_s
      end

      def description
        # NOTE: If a video has no description, YouTube will insert a generic message.
        description = meta_node_value(video_meta_nodes, "og:description")
        return "" if description == DEFAULT_YOUTUBE_DESCRIPTION

        description
      end

      def duration
        duration = itemprop_node_value("duration")

        if duration
          ISO8601::Duration.new(duration).to_seconds.to_i
        else
          0
        end
      end

      def keywords
        return unless available?

        value = meta_node_value(video_meta_nodes, "keywords")

        value&.split(", ")
      end

      def title
        return if meta_node_value(video_meta_nodes, "title").empty?
        meta_node_value(video_meta_nodes, "title")
      end

      def view_count
        interaction_statistics["https://schema.org/WatchAction"]&.to_i || 0
      end

      def stats
        {
          "viewCount" => view_count
        }
      end

      private

      def video_meta_nodes
        @video_meta_nodes ||= data.css("meta")
      end

      def channel_meta_nodes
        @channel_meta_nodes ||= channel_data.css("meta")
      end

      def channel_data
        @channel_data ||= Oga.parse_html(URI.parse(author_url).read)
      end

      def meta_node_value(meta_nodes, name)
        node = meta_nodes.detect do |n|
          n.attr("name")&.value == name || n.attr("property")&.value == name
        end

        return unless node

        node.attr("content")&.value
      end

      def itemprop_node_value(name)
        node = video_meta_nodes.detect do |m|
          itemprop_attr = m.attr("itemprop")

          itemprop_attr.value == name if itemprop_attr
        end

        return unless node
        node.attr("content").value
      end

      def interaction_statistics
        @interaction_statistics ||= begin
          stats = {}
          # Find all divs with itemprop="interactionStatistic"
          interaction_divs = data.css('div[itemprop="interactionStatistic"]')

          interaction_divs.each do |div|
            # Find meta tag with interactionType
            interaction_type_meta = div.css('meta[itemprop="interactionType"]').first
            interaction_type_attr = interaction_type_meta&.attr("content")
            next unless interaction_type_attr

            interaction_type = interaction_type_attr.value

            # Get the userInteractionCount from the same div
            count_meta = div.css('meta[itemprop="userInteractionCount"]').first
            count_attr = count_meta&.attr("content")
            next unless count_attr

            stats[interaction_type] = count_attr.value
          end

          stats
        end
      end

      def _set_data_from_api_impl(api_url)
        # handle fullscreen video URLs
        if url.include?(".com/v/")
          video_id = url.split("/v/")[1].split("?")[0]
          new_url = "https://www.youtube.com/watch?v=" + video_id
          Oga.parse_html(URI.parse(new_url).read)
        else
          Oga.parse_html(URI.parse(api_url).read)
        end
      end

      def _api_url
        uri = URI.parse(@url)

        unless uri.scheme
          uri.path = uri.path.prepend("//")
        end

        uri.scheme = "https"

        uri.to_s
      end
    end
  end
end
