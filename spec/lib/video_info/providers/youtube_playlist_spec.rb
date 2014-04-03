require 'spec_helper'

describe VideoInfo::Providers::YoutubePlaylist do

  describe ".usable?" do
    subject { VideoInfo::Providers::YoutubePlaylist.usable?(url) }

    context "with youtube.com/playlist url" do
      let(:url) { 'http://www.youtube.com/playlist?p=PLA575C81A1FBC04CF' }
      it { should be_true }
    end

    context "with youtube.com url" do
      let(:url) { 'http://www.youtube.com/watch?v=Xp6CXF' }
      it { should be_false }
    end

    context "with other url" do
      let(:url) { 'http://example.com/video1' }
      it { should be_false }
    end
  end

  describe "#available?" do
    context "with valid playlist", :vcr do
      subject { VideoInfo.new('http://www.youtube.com/playlist?p=PLA575C81A1FBC04CF') }
      its(:available?)       { should be_true }
    end

    context "with invalid playlist", :vcr do
      subject { VideoInfo.new('http://www.youtube.com/playlist?p=PLA575C81A1FBC04CF_invalid') }
      its(:available?)       { should be_false }
    end
  end

  context "with playlist PL9hW1uS6HUftLdHI6RIsaf", :vcr do
    let(:videos) {
      [
        VideoInfo.new('http://www.youtube.com/watch?v=_Bt3-WsHfB0'),
        VideoInfo.new('http://www.youtube.com/watch?v=9g2U12SsRns'),
        VideoInfo.new('http://www.youtube.com/watch?v=8b0aEoxqqC0'),
        VideoInfo.new('http://www.youtube.com/watch?v=6c3mHikRz0I'),
        VideoInfo.new('http://www.youtube.com/watch?v=OQVHWsTHcoc')
      ]
    }
    subject { VideoInfo.new('http://www.youtube.com/playlist?p=PL9hW1uS6HUftLdHI6RIsaf-iXTm09qnEr') }

    its(:provider)         { should eq 'YouTube' }
    its(:playlist_id)      { should eq 'PL9hW1uS6HUftLdHI6RIsaf-iXTm09qnEr' }
    its(:url)              { should eq 'http://www.youtube.com/playlist?p=PL9hW1uS6HUftLdHI6RIsaf-iXTm09qnEr' }
    its(:embed_url)        { should eq '//www.youtube.com/embed/videoseries?list=PL9hW1uS6HUftLdHI6RIsaf-iXTm09qnEr' }
    its(:embed_code)       { should eq '<iframe src="//www.youtube.com/embed/videoseries?list=PL9hW1uS6HUftLdHI6RIsaf-iXTm09qnEr" frameborder="0" allowfullscreen="allowfullscreen"></iframe>' }
    its(:title)            { should eq 'YouTube Policy and Copyright' }
    its(:description)      { should eq 'Learn more about copyright basics, flagging, and the YouTube community.' }
    its(:keywords)         { should be_nil }
    its(:duration)         { should be_nil }
    its(:width)            { should be_nil }
    its(:height)           { should be_nil }
    its(:date)             { should be_nil }
    its(:thumbnail_small)  { should eq 'http://i.ytimg.com/vi/8b0aEoxqqC0/default.jpg' }
    its(:thumbnail_medium) { should eq 'http://i.ytimg.com/vi/8b0aEoxqqC0/mqdefault.jpg' }
    its(:thumbnail_large)  { should eq 'http://i.ytimg.com/vi/8b0aEoxqqC0/hqdefault.jpg' }
    its(:videos)           { should match_array(videos) }
    its(:view_count)       { should be_nil }
  end

  context "with playlist PL0E8117603D70E10A in embed path", :vcr do
    subject { VideoInfo.new('http://www.youtube.com/embed/videoseries?list=PL0E8117603D70E10A') }

    its(:playlist_id) { should eq 'PL0E8117603D70E10A' }
    its(:videos) { should eq [] }
  end

  context "with playlist PL9hW1uS6HUftLdHI6RIsaf-iXTm09qnEr in embed path", :vcr do
    subject { VideoInfo.new('http://www.youtube.com/embed/videoseries?list=PL9hW1uS6HUftLdHI6RIsaf-iXTm09qnEr') }

    its(:playlist_id) { should eq 'PL9hW1uS6HUftLdHI6RIsaf-iXTm09qnEr' }
  end


end
