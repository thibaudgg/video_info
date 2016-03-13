class VideoInfo
  module YoutubePlaylistAPI
    def available?
      !data['items'].empty?
    rescue VideoInfo::HttpError
      false
    end

    def description
      data['items'][0]['snippet']['description']
    end

    def date
      nil
    end

    def duration
      nil
    end

    def videos
      _playlist_video_ids.map do |entry_id|
        VideoInfo.new("http://www.youtube.com/watch?v=#{entry_id}")
      end
    end

    def view_count
      nil
    end

    def thumbnail_small
      _video_snippet['thumbnails']['default']['url']
    end

    def thumbnail_medium
      _video_snippet['thumbnails']['medium']['url']
    end

    def thumbnail_large
      _video_snippet['thumbnails']['high']['url']
    end

    private

    def _playlist_entry
      data['items']
    end

    def _playlist_items
      data['items']
    end

    def _api_path
      "/youtube/v3/playlists?part=snippet&id=#{playlist_id}&key=#{api_key}"
    end

    def _playlist_items_api_path
      '/youtube/v3/playlistItems?part=snippet&' \
      "playlistId=#{playlist_id}&fields=items&key=#{api_key}"
    end

    def _playlist_items_api_url
      "https://#{_api_base}#{_playlist_items_api_path}"
    end

    def _playlist_items_data
      @playlist_items_data ||= _set_data_from_api(_playlist_items_api_url)
    end

    def _playlist_video_ids
      _playlist_items_data['items'].map do |item|
        item['snippet']['resourceId']['videoId']
      end
    end
  end
end
