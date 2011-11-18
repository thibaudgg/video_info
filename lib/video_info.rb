require 'provider/vimeo'
require 'provider/youtube'

class VideoInfo

  def initialize(url, options = {})
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
