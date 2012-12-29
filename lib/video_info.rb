require 'open-uri'
require 'multi_json'
require 'providers/vimeo'
require 'providers/youtube'

module VideoInfo

  def self.get(url, options = {})
    options = clean_options(options)
    video = get_video(url, options)
    valid?(video) ? video : nil
  end

private

  def self.get_video(url, options)
    case url
    when /vimeo\.com/
      Vimeo.new(url, options)
    when /(youtube\.com)|(youtu\.be)/
      Youtube.new(url, options)
    end
  end

  def self.valid?(video)
    !video.nil? && !video.video_id.nil? && !['', nil].include?(video.title)
  end

  def self.clean_options(options)
    options = { "User-Agent" => "VideoInfo/#{VideoInfo::VERSION}" }.merge options
    options.dup.each do |key, value|
      unless OpenURI::Options.keys.include?(key) || options[:iframe_attributes]
        if key.is_a? Symbol
          options[key.to_s.split(/[^a-z]/i).map(&:capitalize).join('-')] = value
          options.delete key
        end
      end
    end
    options
  end

  def self.hash_to_attributes(hash)
    s = hash.map{|k,v| "#{k}=\"#{v}\""}.join(' ')
    " #{s}"
  end
end
