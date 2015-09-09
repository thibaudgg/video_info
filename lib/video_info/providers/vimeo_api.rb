class VideoInfo
  module Providers
    module VimeoAPI
      def api_key
        VideoInfo.provider_api_keys[:vimeo]
      end


    end
  end
end
