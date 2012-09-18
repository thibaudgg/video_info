class Vimeo
  attr_accessor :video_id, :embed_url, :embed_code, :url, :provider, :title, :description, :keywords,
                :duration, :date, :width, :height,
                :thumbnail_small, :thumbnail_large,
                :view_count,
                :openURI_options

  def initialize(url, options = {})
    @iframe_attributes = VideoInfo.hash_to_attributes options.delete(:iframe_attributes) if options[:iframe_attributes]
    @openURI_options = options
    @video_id = url.gsub(/.*\.com\/(?:groups\/[^\/]+\/videos\/)?([0-9]+).*$/i, '\1')
    get_info unless @video_id == url || @video_id.nil? || @video_id.empty?
  end

private

  def get_info
    begin
      doc = Hpricot(open("http://vimeo.com/api/v2/video/#{@video_id}.xml", @openURI_options))
      @provider         = "Vimeo"
      @url              = doc.search("url").inner_text
      @embed_url        = "http://player.vimeo.com/video/#{@video_id}"
      @embed_code       = "<iframe src=\"#{@embed_url}?title=0&amp;byline=0&amp;portrait=0&amp;autoplay=0\" frameborder=\"0\"#{@iframe_attributes}></iframe>"
      @title            = doc.search("title").inner_text
      @description      = doc.search("description").inner_text
      @keywords         = doc.search("tags").inner_text
      @duration         = doc.search("duration").inner_text.to_i # seconds
      @width            = doc.search("width").inner_text.to_i
      @height           = doc.search("height").inner_text.to_i
      @date             = Time.parse(doc.search("upload_date").inner_text, Time.now.utc).utc
      @thumbnail_small  = doc.search("thumbnail_small").inner_text
      @thumbnail_large  = doc.search("thumbnail_large").inner_text
      @view_count       = doc.search("stats_number_of_plays").inner_text.to_i
    rescue
      nil
    end
  end

end
