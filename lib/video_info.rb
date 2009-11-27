require 'video'
require 'video/vimeo'
require 'video/youtube'

class VideoInfo
  
  def initialize(url)
    case url
    when /vimeo\.com/
      @video = Vimeo.new(url)
    when /youtube\.com/
      @video = Youtube.new(url)
    end
  end
  
  def valid?
    @video && !["", nil].include?(title)
  end
  
  def method_missing(sym, *args, &block)
    @video.send sym, *args, &block
  end
  
  # def embed(options = {})
  #   width  = options[:width]
  #   height = options[:height]
  #   
  #   allowfullscreen = options[:fullscreen]
  #   fullscreen      = options[:fullscreen]    ? 1 : 0 
  #   show_title      = options[:show_title]    ? 1 : 0
  #   show_byline     = options[:show_byline]   ? 1 : 0
  #   show_portrait   = options[:show_portrait] ? 1 : 0
  #   case provider
  #   when "Youtub"
  #   
  #   %{<object width="#{width}" height="#{height}"><param name="allowfullscreen" value="#{allowfullscreen}" /><param name="allowscriptaccess" value="always" /><param name="movie" value="http://vimeo.com/moogaloop.swf?clip_id=#{id}&amp;server=vimeo.com&amp;show_title=#{show_title}&amp;show_byline=#{show_byline}&amp;show_portrait=#{show_portrait}&amp;color=00adef&amp;fullscreen=#{fullscreen}" /><embed src="http://vimeo.com/moogaloop.swf?clip_id=#{vimeo_id}&amp;server=vimeo.com&amp;show_title=#{show_title}&amp;show_byline=#{show_byline}&amp;show_portrait=#{show_portrait}&amp;color=00adef&amp;fullscreen=#{fullscreen}" type="application/x-shockwave-flash" allowfullscreen="#{allowfullscreen}" allowscriptaccess="always" width="#{options[:width]}" height="#{options[:height]}"></embed></object>}    
  #   %{<object width="#{options[:width]}" height="#{options[:height]}"><param name="movie" value="http://www.youtube.com/v/#{youtube_id}"></param><param name="wmode" value="transparent"></param><embed src="http://www.youtube.com/v/#{id}" type="application/x-shockwave-flash" wmode="transparent" width="#{options[:width]}" height="#{options[:height]}"></embed></object>}
  # end
  
end