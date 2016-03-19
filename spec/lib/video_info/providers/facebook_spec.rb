require 'spec_helper'

describe VideoInfo::Providers::Facebook do
  public_video_from_page_url = 'https://www.facebook.com/freddyolo420/' \
                               'videos/1071390929550268/'

  public_video_from_profile_url = 'https://www.facebook.com/lllDavidACMlll' \
                                  '/videos/10205379584751731/' \
                                  '?__mref=message_bubble'

  before(:all) do
    VideoInfo.provider_api_keys = {
      facebook_app_id: '1526814430954328',
      facebook_app_secret: '1bd1051b2e630584a5fa01a8ebf21cad'
    }
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
      author_thumbnail_url = 'https://scontent.xx.fbcdn.net/hprofile-ash4/v/' \
                             't1.0-1/p50x50/1001098_616848995004466_214403' \
                             '0070_n.png?oh=234c7dab4aa9c322264aabcd625b0e5' \
                             '9&oe=574E35F9'
      subject { super().author_thumbnail }
      it { is_expected.to eq author_thumbnail_url }
    end

    describe '#author_url' do
      author_url = 'https://www.facebook.com/593748813981151'
      subject { super().author_url }
      it { is_expected.to eq author_url }
    end

    describe '#date' do
      subject { super().date }
      it 'should return date posted' do
        is_expected.to eq Time.parse('Fri Feb 27 6:18:01 UTC 2016',
                                     Time.now.utc)
      end
    end

    describe '#description' do
      subject { super().description }
      it { is_expected.to eq "If he visits you it's to late" }
    end

    describe '#width' do
      subject { super().width }
      it { is_expected.to eq nil }
    end

    describe '#height' do
      subject { super().height }
      it { is_expected.to eq nil }
    end

    describe '#duration' do
      subject { super().duration }
      it { is_expected.to eq 10 }
    end

    describe '#title' do
      subject { super().title }
      it { is_expected.to be_nil }
    end

    describe '#thumbnail' do
      thumbnail_url = 'https://scontent.xx.fbcdn.net/hvthumb-xpa1/v/' \
                      't15.0-10/p160x160/12720103_1071391039550257_' \
                      '1997979656_n.jpg?oh=c29fe72d1d3a5be4e81071a0cd' \
                      '877a9a&oe=57528694'
      subject { super().thumbnail }
      it { is_expected.to eq thumbnail_url }
    end

    describe '#thumbnail_small' do
      subject { super().thumbnail_small }
      it { is_expected.to be_nil }
    end

    describe '#thumbnail_medium' do
      subject { super().thumbnail_medium }
      it { is_expected.to be_nil }
    end

    describe '#thumbnail_large' do
      subject { super().thumbnail_large }
      it { is_expected.to be_nil }
    end
  end

  context 'with public video from user profile', :vcr do
    subject { VideoInfo.new(public_video_from_profile_url) }

    describe '#available?' do
      subject { super().available? }
      it { is_expected.to be_truthy }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq '10205379584751731' }
    end
  end
end
