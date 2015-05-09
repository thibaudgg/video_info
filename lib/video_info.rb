require 'video_info/version'
require 'video_info/provider'
require 'forwardable'
require 'net/http'

class VideoInfo
  class UrlError < StandardError; end
  extend Forwardable
  
  PROVIDERS = %w[
    Dailymotion Vkontakte Wistia
    Vimeo VimeoPlaylist
    Youtube YoutubePlaylist
  ]
  PROVIDERS.each { |p| require "video_info/providers/#{p.downcase}" }

  def_delegators :@provider, :provider, :video_id, :video_owner, :url, :data
  def_delegators :@provider, :title, :description, :keywords, :view_count
  def_delegators :@provider, :date, :duration, :width, :height
  def_delegators :@provider, :thumbnail_small, :thumbnail_medium, :thumbnail_large
  def_delegators :@provider, :embed_code, :embed_url
  def_delegators :@provider, :available?
  def_delegators :@provider, :playlist_id, :videos

  def initialize(url, options = {})
    @provider = _select_provider(url, options)
  end

  def self.get(*args)
    new(*args)
  end

  def self.usable?(url)
    new(url)
    true
  rescue UrlError
    false
  end

  def ==(other)
    url == other.url && video_id == other.video_id
  end

  @@disable_providers = []

  def self.disable_providers
    @@disable_providers
  end

  def self.disable_providers=(providers)
    @@disable_providers = providers
  end

  private

  def _select_provider(url, options)
    if provider_const = _providers_const.detect { |p| p.usable?(url) }
      video_info = provider_const.new(url, options)
     
      if defined? video_info.provider and video_info.provider
        if self.class.disable_providers.include? video_info.provider
          raise UrlError, "#{video_info.provider} is disabled"
        end
      end
      video_info
    else
      raise UrlError, "Url is not usable by any Providers: #{url}"
    end
  end

  def _providers_const
    PROVIDERS.map { |p| Providers.const_get(p) }
  end
end
