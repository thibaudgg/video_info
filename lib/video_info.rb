require 'open-uri'
require 'hpricot'
require 'video_info/version'
require 'provider/vimeo'
require 'provider/youtube'

class VideoInfo

  def initialize(url, options = {})

    options = { "User-Agent" => "VideoInfo/#{VideoInfoVersion::VERSION}" }.merge options
    options.dup.each do |key,value|
      unless OpenURI::Options.keys.include? key
        if key.is_a? Symbol
          options[key.to_s.split(/[^a-z]/i).map(&:capitalize).join('-')] = value
          options.delete key
        end
      end
    end

    case url
    when /vimeo\.com/
      @video = Vimeo.new(url, options)
    when /youtube\.com/
      @video = Youtube.new(url, options)
    when /youtu\.be/
      @video = Youtube.new(url, options)
    end
  end

  def valid?
    @video != nil && !["", nil].include?(title)
  end

  def method_missing(sym, *args, &block)
    @video.send sym, *args, &block
  end

end
