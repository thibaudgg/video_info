require 'hpricot'
require 'open-uri'

module Provider
  
  def get_info
    case @url
    # http://www.youtube.com/watch?v=mZqGqE0D0n4
    when /youtube\.com/
      @id = @url.gsub(/.*v=([^&]+).*$/i, '\1')
      youtube_get_info unless @id == @url
    # http://vimeo.com/2199239
    when /vimeo\.com/
      @id = @url.gsub(/.*\.com\/([0-9]+).*$/i, '\1')
      vimeo_get_info unless @id == @url
    end
  rescue
  end
  
private
  
  def youtube_get_info
    doc = Hpricot(open("http://gdata.youtube.com/feeds/api/videos/#{@id}"))
    @provider         = "YouTube"
    @title            = doc.search("media:title").inner_text
    @description      = doc.search("media:description").inner_text
    @keywords         = doc.search("media:keywords").inner_text
    @duration         = doc.search("media:content").first[:duration].to_i # seconds
    @date             = Time.parse(doc.search("published").inner_text, Time.now.utc)
    @thumbnail_small  = doc.search("media:thumbnail").first[:url]
    @thumbnail_large  = doc.search("media:thumbnail").last[:url]
  end
  
  def vimeo_get_info
    doc = Hpricot(open("http://vimeo.com/api/v2/video/#{@id}.xml"))
    @provider         = "Vimeo"
    @title            = doc.search("title").inner_text
    @description      = doc.search("description").inner_text
    @keywords         = doc.search("tags").inner_text
    @duration         = doc.search("duration").inner_text.to_i # seconds
    @date             = Time.parse(doc.search("upload_date").inner_text, Time.now.utc)
    @thumbnail_small  = doc.search("thumbnail_small").inner_text
    @thumbnail_large  = doc.search("thumbnail_large").inner_text
  end
  
end
