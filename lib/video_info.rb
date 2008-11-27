require 'lib/provider'

class VideoInfo
  include Provider
  
  attr_accessor :url, :id, :provider, :title, :description, :keywords, :duration, :date,
                :thumbnail_url, :thumbnail_height, :thumbnail_width, :thumbnail_time
  
  def initialize(url)
    self.url = url
    get_info
  end
  
end