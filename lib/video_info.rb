require 'open-uri'
require 'multi_json'
require 'video_info/version'
require 'providers/vimeo'
require 'providers/youtube'

module VideoInfo
  def self.get(url, options = {})
    options = { "User-Agent" => "VideoInfo/#{VideoInfo::VERSION}" }.merge options
    options.dup.each do |key, value|
      unless OpenURI::Options.keys.include?(key) || options[:iframe_attributes]
        if key.is_a? Symbol
          options[key.to_s.split(/[^a-z]/i).map(&:capitalize).join('-')] = value
          options.delete key
        end
      end
    end

    case url
    when /vimeo\.com/
      @video = Vimeo.new(url, options)
    when /(youtube\.com)|(youtu\.be)/
      @video = Youtube.new(url, options)
    end
  end

  def self.method_missing(sym, *args, &block)
    @video.send sym, *args, &block
  end

  def self.hash_to_attributes(hash)
    s = hash.map{|k,v| "#{k}=\"#{v}\""}.join(' ')
    " #{s}"
  end
end
