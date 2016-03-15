require 'spec_helper'

describe VideoInfo::Providers::Facebook do
  public_video_from_page_url = 'https://www.facebook.com/freddyolo420/' \
                               'videos/1071390929550268/'

  before(:all) do
    VideoInfo.provider_api_keys = { facebook: '' }
  end

  describe '.usable?' do
    subject { VideoInfo::Providers::Facebook.usable?(url) }

    context 'with Facebook page video URL' do
      let(:url) { public_video_from_page_url }
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

  describe '#available?' do
    context 'with public video from page', :vcr do
      subject { VideoInfo.new(public_video_from_page_url) }

      describe '#available?' do
        subject { super().available? }
        it { is_expected.to be_truthy }
      end

      describe '#video_id' do
        subject { super().video_id }
        it { is_expected.to eq '1071390929550268' }
      end

      describe '#author' do
        subject { super().author }
        it { is_expected.to eq 'フレッドYOLO' }
      end

      describe '#author_thumbnail' do
        author_thumbnail_url = 'https://scontent.xx.fbcdn.net/hprofile-ash4/' \
                               'v/t1.0-1/p32x32/1001098_616848995004466' \
                               '_2144030070_n.png?oh=' \
                               'c7e1b20bcffa6e78229df4a1db11828d&oe=575416CD'
        subject { super().author_thumbnail }
        it { is_expected.to eq author_thumbnail_url }
      end

      describe '#author_url' do
        author_url = 'https://www.facebook.com/freddyolo420'
        subject { super().author_url }
        it { is_expected.to eq author_url }
      end
    end
  end
end
