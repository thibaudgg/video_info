class VideoInfo
  module Providers
    class Facebook < Provider
      def self.usable?(url)
        url =~ %r{(facebook\.com\/.*/videos/.*)|
                  (facebook\.com/.*\%2Fvideos%2F)}x
      end
    end
  end
end
