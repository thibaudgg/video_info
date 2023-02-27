require "video_info/version"
require "video_info/provider"
require "forwardable"
require "net/http"
require "logger"

class VideoInfo
  class Error < StandardError; end

  class UrlError < Error; end

  class HttpError < Error; end

  class << self
    attr_writer :logger, :disable_providers

    def disable_providers
      @disable_providers || []
    end

    def provider_api_keys
      @provider_api_keys || {}
    end

    def provider_api_keys=(api_keys)
      api_keys.keys.each do |key|
        raise ArgumentError, "Key must be a symbol!" unless key.is_a?(Symbol)
      end
      @provider_api_keys = api_keys
    end

    def logger
      @logger ||= Logger.new($stdout).tap do |lgr|
        lgr.progname = name
      end
    end
  end

  extend Forwardable

  PROVIDERS = %w[
    Dailymotion Wistia
    Vimeo Youtube YoutubePlaylist
  ].freeze
  PROVIDERS.each { |p| require "video_info/providers/#{p.downcase}" }

  def_delegators :@provider,
    :available?, :provider, :video_id, :video_owner, :url, :data, :data=,
    :title, :description, :keywords, :view_count, :date, :duration, :width, :height,
    :thumbnail, :thumbnail_small, :thumbnail_medium, :thumbnail_large, :thumbnail_large_2x, :thumbnail_maxres,
    :embed_code, :embed_url, :author, :author_thumbnail, :author_url, :playlist_id, :videos

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

  def self.disabled_provider?(provider)
    disable_providers.map(&:downcase).include?(provider.downcase)
  end

  def self.enabled_providers
    PROVIDERS
      .reject { |p| disabled_provider?(p) }
      .map { |p| Providers.const_get(p) }
  end

  def self.valid_url?(url)
    enabled_providers.any? { |p| p.usable?(url) }
  end

  private

  def _select_provider(url, options)
    if (provider_const = _providers_const.detect { |p| p.usable?(url) })
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
