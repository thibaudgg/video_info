require "addressable/uri"

module VideoInfo
  class Provider

    attr_accessor :url, :options, :iframe_attributes, :video_id
    attr_accessor :provider, :title, :description, :keywords, :duration, :date,
      :width, :height, :thumbnail_small, :thumbnail_medium, :thumbnail_large,
      :view_count

    def initialize(url, options = {})
      @options = _clean_options(options)
      @url = url
      _set_video_id_from_url
      _set_info_from_api if _valid_video_id?
    end

    def self.usable?(url)
      raise NotImplementedError.new('Provider class must implement .usable? public method')
    end

    def embed_url(options = {})
      url_protocol = options.fetch(:url_protocol, 'http')

      url_attributes = options.fetch(:url_attributes, {})
      url_attrs = default_url_attributes.merge(url_attributes)

      url = "#{url_protocol}://#{@embed_url}"
      url += "?#{_hash_to_params(url_attrs)}" unless url_attrs.empty?

      url
    end

    def embed_code(options = {})
      url = embed_url(options)

      iframe_attrs = ["src=\"#{url}\"", "frameborder=\"0\""]

      iframe_attributes = options.fetch(:iframe_attributes, {})
      iframe_attrs << _hash_to_attributes(default_iframe_attributes.merge(iframe_attributes))

      "<iframe #{iframe_attrs.reject(&:empty?).join(" ")}></iframe>"
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
      return unless hash.is_a?(Hash)
      hash.map{|k,v| "#{k}=\"#{v}\""}.join(' ')
    end

    def _hash_to_params(hash)
      uri = Addressable::URI.new
      uri.query_values = hash
      uri.query
    end
  end
end
