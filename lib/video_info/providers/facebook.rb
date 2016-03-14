class VideoInfo
  module Providers
    class Facebook < Provider
      def self.usable?(url)
        false
      end
    end
  end
end
