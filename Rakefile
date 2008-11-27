require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('video_info', '0.1.2') do |p|
  p.description    = "Get video info from youtube and vimeo url."
  p.url            = "ttp://github.com/guillaumegentil/video_info"
  p.author         = "Thibaud Guillaume-Gentil"
  p.email          = "guillaumegentil@gmail.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = ["hpricot >=0.6"]
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
