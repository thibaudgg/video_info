require 'spec_helper'

describe VideoInfo::Providers::Vimeo do
  before(:all) do
    VideoInfo.provider_api_keys = { vimeo: '6b66b015a3504793b4f541d878f46ff6' }
  end

  describe '.usable?' do
    subject { VideoInfo::Providers::Vimeo.usable?(url) }

    context 'with vimeo url' do
      let(:url) { 'http://www.vimeo.com/898029' }
      it { is_expected.to be_truthy }
    end

    context 'with Vimeo OnDemand url' do
      let(:url) { 'https://vimeo.com/ondemand/less/101677664' }
      it { is_expected.to be_truthy }
    end

    context 'with Vimeo Channels url' do
      let(:url) { 'https://vimeo.com/channels/any_channel/111431415' }
      it { is_expected.to be_truthy }
    end

    context "with Vimeo Review url" do
      let(:url) { 'https://vimeo.com/user39798190/review/126641548/8a56234e32' }
      it { is_expected.to be_truthy }
    end

    context 'with vimeo album url' do
      let(:url) { 'http://vimeo.com/album/2755718' }
      it { is_expected.to be_falsey }
    end

    context 'with vimeo hubnub embed url' do
      let(:url) { 'http://player.vimeo.com/hubnut/album/2755718' }
      it { is_expected.to be_falsey }
    end

    context 'with other url' do
      let(:url) { 'http://www.youtube.com/898029' }
      it { is_expected.to be_falsey }
    end
  end

  describe '#available?' do
    context 'with valid video', :vcr do
      subject { VideoInfo.new('http://www.vimeo.com/898029') }

      describe '#available?' do
        it { is_expected.to be_available }
      end
    end

    context "with 'this video does not exist' video", :vcr do
      subject { VideoInfo.new('http://vimeo.com/59312311') }

      describe '#available?' do
        it { is_expected.to_not be_available }
      end
    end

    context "with 'password required' video", :vcr do
      subject { VideoInfo.new('http://vimeo.com/74636562') }

      describe '#available?' do
        it { is_expected.to_not be_available }
      end
    end
  end

  context 'with video 898029', :vcr do
    subject { VideoInfo.new('http://www.vimeo.com/898029') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq 'Vimeo' }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq '898029' }
    end

    describe '#url' do
      subject { super().url }
      it { is_expected.to eq 'http://www.vimeo.com/898029' }
    end

    describe '#embed_url' do
      subject { super().embed_url }
      it { is_expected.to eq '//player.vimeo.com/video/898029' }
    end

    describe '#embed_code' do
      subject { super().embed_code }
      it { is_expected.to eq '<iframe src="//player.vimeo.com/video/898029?autoplay=0&byline=0&portrait=0&title=0" frameborder="0"></iframe>' }
    end

    describe '#title' do
      subject { super().title }
      it { is_expected.to eq 'Cherry Bloom - King Of The Knife' }
    end

    describe '#description' do
      subject { super().description }
      it { is_expected.to eq 'The first video from the upcoming album Secret Sounds, to download in-stores April 14. Checkout http://www.cherrybloom.net' }
    end

    describe '#keywords' do
      subject { super().keywords }
      it { is_expected.to eq 'cherry bloom, secret sounds, king of the knife, rock, alternative' }
    end

    describe '#duration' do
      subject { super().duration }
      it { is_expected.to eq 175 }
    end

    describe '#width' do
      subject { super().width }
      it { is_expected.to eq 640 }
    end

    describe '#height' do
      subject { super().height }
      it { is_expected.to eq 360 }
    end

    describe '#date' do
      subject { super().date }
      it { is_expected.to eq Time.parse('2008-04-14T17:10:39+00:00', Time.now.utc).utc }
    end

    describe '#thumbnail_small' do
      subject { super().thumbnail_small }
      it { is_expected.to eq 'https://i.vimeocdn.com/video/34373130_100x75.jpg' }
    end

    describe '#thumbnail_medium' do
      subject { super().thumbnail_medium }
      it { is_expected.to eq 'https://i.vimeocdn.com/video/34373130_200x150.jpg' }
    end

    describe '#thumbnail_large' do
      subject { super().thumbnail_large }
      it { is_expected.to eq 'https://i.vimeocdn.com/video/34373130_640.jpg' }
    end

    describe '#author_thumbnail' do
      subject { super().author_thumbnail }
      it { is_expected.to eq 'https://i.vimeocdn.com/portrait/2577152_75x75.jpg' }
    end

    describe '#author' do
      subject { super().author }
      it { is_expected.to eq 'Octave Zangs' }
    end

    describe '#view_count' do
      subject { super().view_count }
      it { is_expected.to be > 4000 }
    end
  end

  context 'with video 898029 and url_attributes', :vcr do
    subject { VideoInfo.new('http://www.vimeo.com/898029') }

    it { expect(subject.embed_code(url_attributes: { autoplay: 1 })).to match(/autoplay=1/) }
  end

  context 'with video 898029 and iframe_attributes', :vcr do
    subject { VideoInfo.new('http://www.vimeo.com/898029') }

    it { expect(subject.embed_code(iframe_attributes: { width: 800, height: 600 })).to match(/width="800"/) }
    it { expect(subject.embed_code(iframe_attributes: { width: 800, height: 600 })).to match(/height="600"/) }
  end

  context 'with video 898029 in /group/ url', :vcr do
    subject { VideoInfo.new('http://vimeo.com/groups/1234/videos/898029') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq 'Vimeo' }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq '898029' }
    end
  end

  context 'with video 898029 in /group/ url', :vcr do
    subject { VideoInfo.new('http://player.vimeo.com/video/898029') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq 'Vimeo' }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq '898029' }
    end
  end

  context 'with video 898029 in text', :vcr do
    subject { VideoInfo.new('<a href="http://www.vimeo.com/898029">http://www.vimeo.com/898029</a>') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq 'Vimeo' }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq '898029' }
    end
  end

  context 'with video 101677664 in /ondemand/ url', :vcr do
    subject { VideoInfo.new('https://vimeo.com/ondemand/less/101677664') }

    its(:provider) { should eq 'Vimeo' }
    its(:video_id) { should eq '101677664' }
  end

  context 'with video 111431415 in /channels/*/ url', :vcr do
    subject { VideoInfo.new('https://vimeo.com/channels/some_channel1/111431415') }

    its(:provider) { should eq 'Vimeo' }
    its(:video_id) { should eq '111431415' }
  end

  context "with video 126641548 in /user*/review/126641548/* url", :vcr do
    subject { VideoInfo.new('http://www.vimeo.com/user39798190/review/126641548/8a56234e32') }

    its(:provider) { should eq 'Vimeo' }
    its(:video_id) { should eq '126641548' }
  end
end
