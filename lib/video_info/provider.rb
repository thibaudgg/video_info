require 'open-uri'
require 'multi_json'
require 'addressable/uri'

class VideoInfo
  class Provider
    attr_accessor :url, :options, :iframe_attributes, :video_id, :data

    def initialize(url, options = {})
      @options = _clean_options(options)
      @url = url
      _set_video_id_from_url
    end

    def self.usable?(url)
      raise NotImplementedError.new('Provider class must implement .usable? public method')
    end

    def embed_code(options = {})
      iframe_attributes = options.fetch(:iframe_attributes, {})
      iframe_attrs = ["src=\"#{_embed_url(options)}\"", "frameborder=\"0\""]
      iframe_attrs << _hash_to_attributes(_default_iframe_attributes.merge(iframe_attributes))

      "<iframe #{iframe_attrs.reject(&:empty?).join(" ")}></iframe>"
    end

    def data
      @data ||= _set_data_from_api
    end


    def available?
      !%w[403 404].include?(_response_code)
    end

    private

    def _response_code
      response = nil
      Net::HTTP.start(_api_base, 80) {|http|
        response = http.head(_api_path)
      }
      response.code
    end

    def _clean_options(options)
      options = { 'User-Agent' => "VideoInfo/#{VideoInfo::VERSION}" }.merge(options)
      options.dup.each do |key, value|
        if _not_openuri_option_symbol?(key)
          options[_http_header_field(key)] = value
          options.delete key
        end
      end
      options
    end

    def _set_data_from_api
      uri = open(_api_url, options)
      MultiJson.load(uri.read)
    end

    def _not_openuri_option_symbol?(key)
      key.is_a?(Symbol) && !OpenURI::Options.keys.include?(key)
    end

    def _http_header_field(key)
      key.to_s.split(/[^a-z]/i).map(&:capitalize).join('-')
    end

    def _set_video_id_from_url
      @url.gsub(_url_regex) { @video_id = $1 || $2 || $3 }
      unless _valid_video_id?
        raise UrlError, "Url is not valid, video_id is not found: #{url}"
      end
    end

    def _valid_video_id?
      video_id && video_id != url && !video_id.empty?
    end

    def _url_regex
      raise NotImplementedError.new('Provider class must implement #_url_regex private method')
    end

    def _api_url
      raise NotImplementedError.new('Provider class must implement #_api_url private method')
    end

    def _embed_url(options)
      url_attrs = options.fetch(:url_attributes, {})
      url_attrs = _default_url_attributes.merge(url_attrs)

      url = embed_url
      url += "?#{_hash_to_params(url_attrs)}" unless url_attrs.empty?
      url
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
