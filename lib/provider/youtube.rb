require 'hpricot'
require 'open-uri'

class Youtube
  attr_accessor :video_id, :url, :provider, :title, :description, :keywords,
                :duration, :date, :width, :height,
                :thumbnail_small, :thumbnail_large,
                :view_count
  
  def initialize(url)
    @video_id = url.gsub(/.*v=([^&]+).*$/i, '\1')
    get_info unless @video_id == url
  end
  
private
  
  def get_info
    doc = Hpricot(open("http://gdata.youtube.com/feeds/api/videos/#{@video_id}"))
    @provider         = "YouTube"
    @url              = "http://www.youtube.com/watch?v=#{@video_id}"
    @title            = doc.search("media:title").inner_text
    @description      = doc.search("media:description").inner_text
    @keywords         = doc.search("media:keywords").inner_text
    @duration         = doc.search("yt:duration").first[:seconds].to_i
    @date             = Time.parse(doc.search("published").inner_text, Time.now.utc)
    @thumbnail_small  = doc.search("media:thumbnail").first[:url]
    @thumbnail_large  = doc.search("media:thumbnail").last[:url]
    @view_count       = doc.search("yt:statistics").first[:viewcount].to_i
  end
  
end