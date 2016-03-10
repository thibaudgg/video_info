require 'spec_helper'

describe VideoInfo::Providers::YoutubePlaylist do
  before(:all) do
    VideoInfo.provider_api_keys = {}
  end

  describe ".usable?" do
    subject { VideoInfo::Providers::YoutubePlaylist.usable?(url) }

    context "with youtube.com/playlist?p= url" do
      let(:url) { 'http://www.youtube.com/playlist?p=PLA575C81A1FBC04CF' }
      it { is_expected.to be_truthy }
    end

    context "with youtube.com/playlist?list= url" do
      let(:url) { 'http://www.youtube.com/playlist?list=PLA575C81A1FBC04CF' }
      it { is_expected.to be_truthy }
    end

    context "with youtube.com url" do
      let(:url) { 'http://www.youtube.com/watch?v=Xp6CXF' }
      it { is_expected.to be_falsey }
    end

    context "with other url" do
      let(:url) { 'http://example.com/video1' }
      it { is_expected.to be_falsey }
    end
  end

  describe "#available?" do
    context "with valid playlist", :vcr do
      subject { VideoInfo.new('http://www.youtube.com/playlist?p=PLA575C81A1FBC04CF') }

      describe '#available?' do
        subject { super().available? }
        it { is_expected.to be_truthy }
      end
    end

    context "with invalid playlist", :vcr do
      subject { VideoInfo.new('http://www.youtube.com/playlist?p=PLA575C81A1FBC04CF_invalid') }

      describe '#available?' do
        subject { super().available? }
        it { is_expected.to be_falsey }
      end
    end

    context "with &list= url", :vcr do
      subject { VideoInfo.new('http://www.youtube.com/playlist?list=PLA575C81A1FBC04CF') }

      describe '#available?' do
        subject { super().available? }
        it { is_expected.to be_truthy }
      end
    end
  end

  context "with playlist PL9hW1uS6HUftLdHI6RIsaf", :vcr do
    let(:videos) {
      [
        VideoInfo.new('http://www.youtube.com/watch?v=Oi67QjrXy2w'),
        VideoInfo.new('http://www.youtube.com/watch?v=_Bt3-WsHfB0'),
        VideoInfo.new('http://www.youtube.com/watch?v=9g2U12SsRns'),
        VideoInfo.new('http://www.youtube.com/watch?v=8b0aEoxqqC0'),
        VideoInfo.new('http://www.youtube.com/watch?v=6c3mHikRz0I'),
        VideoInfo.new('http://www.youtube.com/watch?v=OQVHWsTHcoc')
      ]
    }
    subject { VideoInfo.new('http://www.youtube.com/playlist?p=PL9hW1uS6HUftLdHI6RIsaf-iXTm09qnEr') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq 'YouTube' }
    end

    describe '#playlist_id' do
      subject { super().playlist_id }
      it { is_expected.to eq 'PL9hW1uS6HUftLdHI6RIsaf-iXTm09qnEr' }
    end

    describe '#url' do
      subject { super().url }
      it { is_expected.to eq 'http://www.youtube.com/playlist?p=PL9hW1uS6HUftLdHI6RIsaf-iXTm09qnEr' }
    end

    describe '#embed_url' do
      subject { super().embed_url }
      it { is_expected.to eq '//www.youtube.com/embed/videoseries?list=PL9hW1uS6HUftLdHI6RIsaf-iXTm09qnEr' }
    end

    describe '#embed_code' do
      subject { super().embed_code }
      embed_code = '<iframe src="//www.youtube.com/embed/videoseries' \
                   '?list=PL9hW1uS6HUftLdHI6RIsaf-iXTm09qnEr" ' \
                   'frameborder="0" allowfullscreen="allowfullscreen">' \
                   '</iframe>'
      it { is_expected.to eq embed_code }
    end

    describe '#title' do
      subject { super().title }
      it { is_expected.to eq 'YouTube Policy and Copyright' }
    end

    describe '#description' do
      subject { super().description }
      it { is_expected.to eq 'Learn more about copyright basics, flagging, and the YouTube community.' }
    end

    describe '#keywords' do
      subject { super().keywords }
      it { is_expected.to be_nil }
    end

    describe '#duration' do
      subject { super().duration }
      it { is_expected.to be_nil }
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
      it { is_expected.to be_nil }
    end

    describe '#thumbnail_small' do
      subject { super().thumbnail_small }
      it { is_expected.to eq 'https://i.ytimg.com/vi/8b0aEoxqqC0/default.jpg' }
    end

    describe '#thumbnail_medium' do
      subject { super().thumbnail_medium }
      it { is_expected.to eq 'https://i.ytimg.com/vi/8b0aEoxqqC0/mqdefault.jpg' }
    end

    describe '#thumbnail_large' do
      subject { super().thumbnail_large }
      it { is_expected.to eq 'https://i.ytimg.com/vi/8b0aEoxqqC0/hqdefault.jpg' }
    end

    describe '#videos' do
      subject { super().videos }
      it { expect { subject }.to raise_error(NotImplementedError) }
    end

    describe '#view_count' do
      subject { super().view_count }
      it { is_expected.to be_nil }
    end

    describe '#author' do
      subject { super().author }
      it { is_expected.to eq 'YouTube Help' }
    end

    describe '#author_thumbnail' do
      subject { super().author_thumbnail }
      it { is_expected.to eq 'https://yt3.ggpht.com/-ni_VaN38-AE/AAAAAAAAAAI/AAAAAAAAAAA/bJCTTfihBl0/s100-c-k-no/photo.jpg' }
    end

    describe '#author_url' do
      subject { super().author_url }
      it { is_expected.to eq 'https://www.youtube.com/user/YouTubeHelp' }
    end

  end

  context 'with playlist PL0E8117603D70E10A in embed path', :vcr do
    playlist_url = 'http://www.youtube.com/embed/videoseries?' \
                   'list=PL0E8117603D70E10A'
    subject { VideoInfo.new(playlist_url) }

    describe '#playlist_id' do
      subject { super().playlist_id }
      it { is_expected.to eq 'PL0E8117603D70E10A' }
    end

    describe '#videos' do
      subject { super().videos }
      it { expect { subject }.to raise_error(NotImplementedError) }
    end
  end

  context 'with playlist PL9hW1uS6HUftLdHI6RIsaf-iXTm09qnEr in embed path', :vcr do
    playlist_url = 'http://www.youtube.com/embed/videoseries' \
                   '?list=PL9hW1uS6HUftLdHI6RIsaf-iXTm09qnEr'
    subject { VideoInfo.new(playlist_url) }

    describe '#playlist_id' do
      subject { super().playlist_id }
      it { is_expected.to eq 'PL9hW1uS6HUftLdHI6RIsaf-iXTm09qnEr' }
    end
  end
end
