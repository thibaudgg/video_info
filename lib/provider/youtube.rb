require 'hpricot'
require 'open-uri'

class Youtube
  attr_accessor :url, :id, :provider, :title, :description, :keywords,
                :duration, :date, :width, :height,
                :thumbnail_small, :thumbnail_large
  
  def initialize(url)
    @id = url.gsub(/.*v=([^&]+).*$/i, '\1')
    get_info unless @id == url
  end
  
private
  
  def get_info
    doc = Hpricot(open("http://gdata.youtube.com/feeds/api/videos/#{@id}"))
    @provider         = "YouTube"
    @url              = "http://www.youtube.com/watch?v=#{@id}"
    @title            = doc.search("media:title").inner_text
    @description      = doc.search("media:description").inner_text
    @keywords         = doc.search("media:keywords").inner_text
    @duration         = doc.search("media:content").first[:duration].to_i # seconds
    @date             = Time.parse(doc.search("published").inner_text, Time.now.utc)
    @thumbnail_small  = doc.search("media:thumbnail").first[:url]
    @thumbnail_large  = doc.search("media:thumbnail").last[:url]
  end
  
end