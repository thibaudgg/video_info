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
  def_delegators :@provider, :thumbnail
  def_delegators :@provider, :thumbnail_small, :thumbnail_medium, :thumbnail_large
  def_delegators :@provider, :embed_code, :embed_url
  def_delegators :@provider, :available?
  def_delegators :@provider, :playlist_id, :videos
  def_delegators :@provider, :author, :author_thumbnail
  def_delegators :@provider, :data=
  
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

  @@provider_api_keys = {}

  def self.provider_api_keys
    @@provider_api_keys
  end

  def self.provider_api_keys=(api_keys)
    api_keys.keys.each do |key|
      raise ArgumentError, 'Key must be a symbol!' unless key.is_a?(Symbol)
    end
    @@provider_api_keys = api_keys
  end

  @@disable_providers = []

  def self.disable_providers
    @@disable_providers
  end

  def self.disable_providers=(providers)
    @@disable_providers = providers
  end

  def self.disabled_provider?(provider)
    disable_providers.map(&:downcase).include?(provider.downcase)
  end

  private

  def _select_provider(url, options)
    if provider_const = _providers_const.detect { |p| p.usable?(url) }
      const_provider = provider_const.new(url, options)

      if defined?(const_provider.provider) && const_provider.provider
        ensure_enabled_provider(const_provider.provider)
      end

      const_provider
    else
      raise UrlError, "Url is not usable by any Providers: #{url}"
    end
  end

  def _providers_const
    PROVIDERS.map { |p| Providers.const_get(p) }
  end

  def ensure_enabled_provider(provider)
    if self.class.disabled_provider?(provider)
      raise UrlError, "#{provider} is disabled"
    end
  end
end
