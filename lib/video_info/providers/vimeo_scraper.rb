require "oga"
require "cgi"

class VideoInfo
  module Providers
    module VimeoScraper
      def author
        if available?
          json_info["author"]["name"]
        end
      end

      def author_thumbnail
        unless available?
          return nil
        end

        json_info["author"]["image"]
      end

      def author_url
        if available?
          json_info["author"]["url"]
        end
      end

      def available?
        is_available = super

        if data.nil?
          is_available = false
        end

        if json_info.nil?
          is_available = false
        end

        is_available
      end

      def title
        meta_node_value("og:title")
      end

      def description
        meta_node_value("og:description")
      end

      def date
        if available?
          upload_date = json_info["uploadDate"]
          ISO8601::DateTime.new(upload_date).to_time
        end
      end

      def duration
        if available?
          duration = json_info["duration"]
          ISO8601::Duration.new(duration).to_seconds.to_i
        end
      end

      def keywords
        unless available?
          return nil
        end

        json_info["keywords"] || []
      end

      def height
        if available?
          json_info["height"]
        end
      end

      def width
        if available?
          json_info["width"]
        end
      end

      def thumbnail_small
        if available?
          thumbnail_url.split("_")[0] + "_100x75.jpg"
        end
      end

      def thumbnail_medium
        if available?
          thumbnail_url.split("_")[0] + "_200x150.jpg"
        end
      end

      def thumbnail_large
        if available?
          thumbnail_url.split("_")[0] + "_640.jpg"
        end
      end

      def view_count
        if available?
          user_interaction_count(interaction_type: "WatchAction")
        end
      end

      def stats
        return {} unless available?
        {
          "plays" => view_count,
          "likes" => user_interaction_count(interaction_type: "LikeAction"),
          "comments" => user_interaction_count(interaction_type: "CommentAction")
        }
      end

      private

      def user_interaction_count(interaction_type:)
        interaction_statistic&.find do |stat|
          stat["interactionType"] == "http://schema.org/#{interaction_type}"
        end&.public_send(:[], "userInteractionCount")
      end

      def interaction_statistic
        json_info["interactionStatistic"]
      end

      def json_info
        @json_info ||= begin
          return nil if data.nil?

          script_elements = data.css("script")
          script_element = script_elements.detect do |n|
            type = n.attr("type")
            if type.nil?
              false
            else
              type.value == "application/ld+json"
            end
          end
          return nil if script_element.nil?
          JSON.parse(script_element.text)[0]
        rescue JSON::ParserError
          nil
        end
      end

      def thumbnail_url
        @thumbnail_url ||= remove_overlay(meta_node_value("og:image"))
      end

      def remove_overlay(url)
        uri = URI.parse(url)

        if uri.path == "/filter/overlay"
          CGI.parse(uri.query)["src0"][0]
        else
          url
        end
      end

      def meta_nodes
        @meta_nodes ||= data.css("meta")
      end

      def meta_node_value(name)
        if available?
          node = meta_nodes.detect do |n|
            property = n.attr("property")

            if property.nil?
              false
            else
              property.value == name
            end
          end

          node.attr("content").value
        end
      end

      def _set_data_from_api_impl(api_url)
        Oga.parse_html(URI.parse(api_url.to_s).read)
      rescue OpenURI::HTTPError
        nil
      end

      def _api_url
        uri = URI.parse(@url)
        uri.scheme = "https"
        uri.to_s
      end

      def _api_path
        _api_url
      end
    end
  end
end
