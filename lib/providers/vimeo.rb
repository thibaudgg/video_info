module VideoInfo
  class Vimeo
    attr_accessor :video_id, :embed_url, :embed_code, :url, :provider, :title, :description, :keywords,
                  :duration, :date, :width, :height,
                  :thumbnail_small, :thumbnail_medium, :thumbnail_large,
                  :view_count,
                  :openURI_options

    def initialize(url, options = {})
      if iframe_attributes = options.delete(:iframe_attributes)
        @iframe_attributes = VideoInfo.hash_to_attributes iframe_attributes
      end

      @openURI_options = options
      @video_id = url.gsub(/.*\.com\/(?:groups\/[^\/]+\/videos\/)?([0-9]+).*$/i, '\1')
      get_info unless @video_id == url || @video_id.nil? || @video_id.empty?
    end

    def valid?
      !@video_id.nil? && !['', nil].include?(@title)
    end

    private

    def get_info
      begin
        uri   = open("http://vimeo.com/api/v2/video/#{@video_id}.json", @openURI_options)
        video = MultiJson.load(uri.read).first
        @provider         = "Vimeo"
        @url              = video['url']
        @embed_url        = "http://player.vimeo.com/video/#{@video_id}"
        @embed_code       = "<iframe src=\"#{@embed_url}?title=0&amp;byline=0&amp;portrait=0&amp;autoplay=0\" frameborder=\"0\"#{@iframe_attributes}></iframe>"
        @title            = video['title']
        @description      = video['description']
        @keywords         = video['tags']
        @duration         = video['duration'].to_i # seconds
        @width            = video['width'].to_i
        @height           = video['height'].to_i
        @date             = Time.parse(video['upload_date'], Time.now.utc).utc
        @thumbnail_small  = video['thumbnail_small']
        @thumbnail_medium = video['thumbnail_medium']
        @thumbnail_large  = video['thumbnail_large']
        @view_count       = video['stats_number_of_plays'].to_i
      rescue
        nil
      end
    end
  end
end
