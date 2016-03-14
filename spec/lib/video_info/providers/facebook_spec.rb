require 'spec_helper'

describe VideoInfo::Providers::Facebook do
  describe '.usable?' do
    subject { VideoInfo::Providers::Facebook.usable?(url) }

    context 'with Facebook page video URL' do
      url = 'https://www.facebook.com/freddyolo420/videos/1071390929550268/'
      let(:url) { url }
      it { is_expected.to be_truthy }
    end

    context 'with mobile Facebook story video URL' do
      url = 'https://m.facebook.com/story.php?story_fbid=1071390929550268&' \
            'id=593748813981151&refsrc=https%3A%2F%2Fm.facebook.com' \
            '%2Ffreddyolo420%2Fvideos%2F1071390929550268%2F&_rdr'
      let(:url) { url }
      it { is_expected.to be_truthy }
    end

    context 'with other url' do
      let(:url) { 'http://google.com' }
      it { is_expected.to be_falsey }
    end
  end
end
