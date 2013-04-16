module VideoInfo
  class Provider

    attr_accessor :url, :options, :iframe_attributes, :video_id
    attr_accessor :embed_url, :embed_code, :provider, :title, :description, :keywords,
                  :duration, :date, :width, :height,
                  :thumbnail_small, :thumbnail_medium, :thumbnail_large,
                  :view_count

    def initialize(url, options = {}, iframe_attributes = nil)
      @iframe_attributes = _hash_to_attributes(options.delete(:iframe_attributes))
      @options = _clean_options(options)
      @url = url
      _set_video_id_from_url
      _set_info_from_api if _valid_video_id?
    end

    def self.usable?(url)
      raise NotImplementedError.new('Provider class must implement .usable? public method')
    end

    private

    def _set_video_id_from_url
      url.gsub(_url_regex) { @video_id = $1 || $2 || $3 }
    end

    def _valid_video_id?
      video_id && video_id != url && !video_id.empty?
    end

    def _url_regex
      raise NotImplementedError.new('Provider class must implement #_url_regex private method')
    end

    def _set_info_from_api
      raise NotImplementedError.new('Provider class must implement #_set_info_from_api private method')
    end

    def _clean_options(options)
      options = { 'User-Agent' => "VideoInfo/#{VideoInfo::VERSION}" }.merge(options)
      options.dup.each do |key, value|
        if key.is_a?(Symbol) && !OpenURI::Options.keys.include?(key)
          options[key.to_s.split(/[^a-z]/i).map(&:capitalize).join('-')] = value
          options.delete key
        end
      end
      options
    end

    def _hash_to_attributes(hash)
      if hash.is_a?(Hash)
        s = hash.map{|k,v| "#{k}=\"#{v}\""}.join(' ')
        " #{s}"
      end
    end
  end
end
