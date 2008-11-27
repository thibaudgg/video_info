require 'hpricot'
require 'open-uri'

module Provider
  
  def get_info
    case @url
    when /youtube\.com/
      youtube_get_info
    when /vimeo\.com/
      vimeo_get_info
    end
  rescue
  end
  
private
  
  def youtube_get_info
    # http://www.youtube.com/watch?v=mZqGqE0D0n4
    @id = @url.gsub(/.*v=([^&]*).*$/i, '\1')
    doc = Hpricot(open("http://gdata.youtube.com/feeds/api/videos/#{@id}"))
    @provider         = "YouTube"
    @title            = doc.search("media:title").inner_text
    @description      = doc.search("media:description").inner_text
    @keywords         = doc.search("media:keywords").inner_text
    @duration         = doc.search("media:content").first[:duration] # seconds
    @date             = Time.parse(doc.search("published").inner_text, Time.now.utc)
    @thumbnail_url    = doc.search("media:thumbnail").first[:url]
    @thumbnail_height = doc.search("media:thumbnail").first[:height]
    @thumbnail_width  = doc.search("media:thumbnail").first[:width]
    @thumbnail_time   = doc.search("media:thumbnail").first[:time]
  end
  
  def vimeo_get_info
    # http://vimeo.com/2199239
    @id = @url.gsub(/.*\.com\/([0-9]*).*$/i, '\1')
    doc = Hpricot(open("http://vimeo.com/api/clip/#{@id}.xml"))
    @provider         = "Vimeo"
    @title            = doc.search("title").inner_text
    @description      = doc.search("caption").inner_text
    @keywords         = doc.search("tags").inner_text
    @duration         = doc.search("duration").inner_text # seconds
    @date             = Time.parse(doc.search("upload_date").inner_text, Time.now.utc)
    @thumbnail_url    = doc.search("thumbnail_large").inner_text
    @thumbnail_width  = 160
  end
  
end
