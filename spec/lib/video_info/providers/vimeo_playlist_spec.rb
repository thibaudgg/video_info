require 'spec_helper'

describe VideoInfo::Providers::VimeoPlaylist do
  before(:all) do
    VideoInfo.provider_api_keys = { vimeo: '6b66b015a3504793b4f541d878f46ff6' }
  end

  describe '.usable?' do
    subject { VideoInfo::Providers::VimeoPlaylist.usable?(url) }

    context 'with vimeo album url' do
      let(:url) { 'http://vimeo.com/album/2755718' }
      it { is_expected.to be_truthy }
    end

    context 'with vimeo hubnub embed url' do
      let(:url) { 'http://player.vimeo.com/hubnut/album/2755718' }
      it { is_expected.to be_truthy }
    end

    context 'with vimeo url' do
      let(:url) { 'http://www.vimeo.com/898029' }
      it { is_expected.to be_falsey }
    end

    context 'with other url' do
      let(:url) { 'http://www.youtube.com/898029' }
      it { is_expected.to be_falsey }
    end
  end

  describe '#available?' do
    context 'with valid playlist', :vcr do
      subject { VideoInfo.new('http://vimeo.com/album/2755718') }

      describe '#available?' do
        subject { super().available? }
        it { is_expected.to be_truthy }
      end
    end

    context 'with invalid playlist', :vcr do
      subject { VideoInfo.new('http://vimeo.com/album/2') }

      describe '#available?' do
        subject { super().available? }
        it { is_expected.to be_falsey }
      end
    end
  end

  context 'with playlist 1921098', :vcr do
    let(:videos) {
      [
        39837353, 40170418, 38809325, 38445453,
        38445381, 38445243, 38394965, 42647970
      ].map do |video_id|
        VideoInfo.new("https://vimeo.com/#{video_id}")
      end
    }
    subject { VideoInfo.new('http://vimeo.com/album/1921098') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq 'Vimeo' }
    end

    describe '#playlist_id' do
      subject { super().playlist_id }
      it { is_expected.to eq '1921098' }
    end

    describe '#url' do
      subject { super().url }
      it { is_expected.to eq 'http://vimeo.com/album/1921098' }
    end

    describe '#embed_url' do
      subject { super().embed_url }
      it { is_expected.to eq '//player.vimeo.com/hubnut/album/1921098' }
    end

    describe '#embed_code' do
      subject { super().embed_code }
      it { is_expected.to eq "<iframe src=\"//player.vimeo.com/hubnut/album/1921098?autoplay=0&byline=0&portrait=0&title=0\" frameborder=\"0\"></iframe>" }
    end

    describe '#title' do
      subject { super().title }
      it { is_expected.to eq 'Get To Know The New Vimeo' }
    end

    describe '#description' do
      subject { super().description }
      it { is_expected.to eq 'Tutorials to get you started in the brand new Vimeo!' }
    end

    describe '#keywords' do
      subject { super().keywords }
      it { is_expected.to be_nil }
    end

    describe '#duration' do
      subject { super().duration }
      it { is_expected.to eq 1254 }
    end

    describe '#width' do
      subject { super().width }
      it { is_expected.to be_nil }
    end

    describe '#height' do
      subject { super().height }
      it { is_expected.to be_nil }
    end

    describe '#date' do
      subject { super().date }
      it { is_expected.to eq Time.parse('2012-04-30T15:00:53+00:00', Time.now.utc).utc }
    end

    describe '#thumbnail_small' do
      subject { super().thumbnail_small }
      it { is_expected.to eq 'https://i.vimeocdn.com/video/299773432_100x75.jpg' }
    end

    describe '#thumbnail_medium' do
      subject { super().thumbnail_medium }
      it { is_expected.to eq 'https://i.vimeocdn.com/video/299773432_200x150.jpg' }
    end

    describe '#thumbnail_large' do
      subject { super().thumbnail_large }
      it { is_expected.to eq 'https://i.vimeocdn.com/video/299773432_640.jpg' }
    end

    describe '#videos' do
      subject { super().videos }
      it { is_expected.to match_array(videos) }
    end

    describe '#view_count' do
      subject { super().view_count }
      it { is_expected.to be_nil }
    end
  end

  context 'with playlist 2755718 in embed path', :vcr do
    subject { VideoInfo.new('http://player.vimeo.com/hubnut/album/2755718') }

    describe '#playlist_id' do
      subject { super().playlist_id }
      it { is_expected.to eq '2755718' }
    end
  end
end
