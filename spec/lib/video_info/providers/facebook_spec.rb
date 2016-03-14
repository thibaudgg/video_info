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

    context 'with Facebook page URL' do
      url = 'https://www.facebook.com/freddyolo420'
      let(:url) { url }
      it { is_expected.to be_falsey }
    end

    context 'with Facebook page videos list page' do
      url = 'https://www.facebook.com/freddyolo420/videos'
      let(:url) { url }
      it { is_expected.to be_falsey }
    end

    context 'with Facebook page photo page' do
      url = 'https://www.facebook.com/freddyolo420/photos/pb.593748813981151' \
            '.-2207520000.1457977944./1080457915310236/?type=3&theater'
      let(:url) { url }
      it { is_expected.to be_falsey }
    end

    context 'with Facebook profile URL' do
      url = 'https://www.facebook.com/vincent.heuken'
      let(:url) { url }
      it { is_expected.to be_falsey }
    end

    context 'with Facebook profile video URL' do
      url = 'https://www.facebook.com/vincent.heuken/videos/' \
            '10206065040175225/?permPage=1'
      let(:url) { url }
      it { is_expected.to be_truthy }
    end

    context 'with Facebook profile theater video URL' do
      url = 'https://www.facebook.com/vincent.heuken/videos/' \
            'vb.1538564816/10206065040175225/?type=3&theater'
      let(:url) { url }
      it { is_expected.to be_truthy }
    end

    context 'with other url' do
      let(:url) { 'http://google.com' }
      it { is_expected.to be_falsey }
    end
  end
end
