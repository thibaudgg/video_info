require 'video_info/version'
require 'video_info/provider'

module VideoInfo
  PROVIDERS = %w[Vimeo Youtube]
  PROVIDERS.each { |p| require "video_info/providers/#{p.downcase}" }

  def self.get(url, options = {})
    if provider_const = _providers_const.detect { |p| p.usable?(url) }
      provider_const.new(url, options)
    end
  end

  def self.usable?(url)
    !!_providers_const.detect { |p| p.usable?(url) }
  end

  def self.embed_code(url, options = {})
    if provider_const = _providers_const.detect { |p| p.usable?(url) }
      provider_const.new(url, {:skip_api_call => true}).embed_code(options)
    end    
  end
  private

  def self._providers_const
    PROVIDERS.map { |p| Providers.const_get(p) }
  end
end
