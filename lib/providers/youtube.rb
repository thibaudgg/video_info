class Youtube
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
    video_id_for(url)
    get_info unless @video_id == url || @video_id.nil? || @video_id.empty?
  end

  def regex
    /youtu(.be)?(be.com)?.*(?:\/|v=)([\w-]+)/
  end

  def video_id_for(url)
    url.gsub(regex) do
      @video_id = $3
    end
  end

  private

  def get_info
    begin
      uri   = open("http://gdata.youtube.com/feeds/api/videos/#{@video_id}?v=2&alt=json", @openURI_options)
      video = MultiJson.load(uri.read)
      @provider         = "YouTube"
      @url              = "http://www.youtube.com/watch?v=#{@video_id}"
      @embed_url        = "http://www.youtube.com/embed/#{@video_id}"
      @embed_code       = "<iframe src=\"#{@embed_url}\" frameborder=\"0\" allowfullscreen=\"allowfullscreen\"#{@iframe_attributes}></iframe>"
      @title            = video['entry']['title']['$t']
      @description      = video['entry']['media$group']['media$description']['$t']
      @keywords         = video['entry']['media$group']['media$keywords']['$t']
      @duration         = video['entry']['media$group']['yt$duration']['seconds'].to_i
      @date             = Time.parse(video['entry']['published']['$t'], Time.now.utc)
      @thumbnail_small  = video['entry']['media$group']['media$thumbnail'][0]['url']
      @thumbnail_medium = video['entry']['media$group']['media$thumbnail'][1]['url']
      @thumbnail_large  = video['entry']['media$group']['media$thumbnail'][2]['url']
      # when your video still has no view, yt:statistics is not returned by Youtube
      # see: https://github.com/thibaudgg/video_info/issues/2
      if video['entry']['yt$statistics']
        @view_count     = video['entry']['yt$statistics']['viewCount'].to_i
      else
        @view_count     = 0
      end
    rescue
      nil
    end
  end
end
