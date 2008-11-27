require 'lib/video_info'

task :get_info do
  url = ENV['URL']
  video = VideoInfo.new(url)
  p video
end