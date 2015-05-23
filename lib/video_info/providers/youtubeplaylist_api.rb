class VideoInfo
  module YoutubePlaylistAPI
    def description
      data['items'][0]['snippet']['description']
    end

    def videos
      _playlist_video_ids.map do |entry_id|
        VideoInfo.new("http://www.youtube.com/watch?v=#{entry_id}")
      end
    end
  end
end
