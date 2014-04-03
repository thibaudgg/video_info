require 'spec_helper'

describe VideoInfo::Providers::VimeoPlaylist do

  describe ".usable?" do
    subject { VideoInfo::Providers::VimeoPlaylist.usable?(url) }

    context "with vimeo album url" do
      let(:url) { 'http://vimeo.com/album/2755718' }
      it { should be_true }
    end

    context "with vimeo hubnub embed url" do
      let(:url) { 'http://player.vimeo.com/hubnut/album/2755718' }
      it { should be_true }
    end

    context "with vimeo url" do
      let(:url) { 'http://www.vimeo.com/898029' }
      it { should be_false }
    end

    context "with other url" do
      let(:url) { 'http://www.youtube.com/898029' }
      it { should be_false }
    end
  end

  describe "#available?" do
    context "with valid playlist", :vcr do
      subject { VideoInfo.new('http://vimeo.com/album/2755718') }
      its(:available?)       { should be_true }
    end

    context "with invalid playlist", :vcr do
      subject { VideoInfo.new('http://vimeo.com/album/2') }
      its(:available?)       { should be_false }
    end
  end


  context "with playlist 2755718", :vcr do
    let(:videos) {
      [
        VideoInfo.new('http://vimeo.com/67977038'),
        VideoInfo.new('http://vimeo.com/68843810'),
        VideoInfo.new('http://vimeo.com/69949597'),
        VideoInfo.new('http://vimeo.com/70388245')
      ]
    }
    subject { VideoInfo.new('http://vimeo.com/album/2755718') }

    its(:provider)         { should eq 'Vimeo' }
    its(:playlist_id)      { should eq '2755718' }
    its(:url)              { should eq 'http://vimeo.com/album/2755718' }
    its(:embed_url)        { should eq '//player.vimeo.com/hubnut/album/2755718' }
    its(:embed_code)       { should eq '<iframe src="//player.vimeo.com/hubnut/album/2755718?autoplay=0&byline=0&portrait=0&title=0" frameborder="0"></iframe>' }
    its(:title)            { should eq 'The Century Of Self' }
    its(:description)      { should eq 'The Century of the Self is an award-winning British television documentary series by Adam Curtis, released in 2002.' }
    its(:keywords)         { should be_nil }
    its(:duration)         { should be_nil }
    its(:width)            { should be_nil }
    its(:height)           { should be_nil }
    its(:date)             { should be_nil }
    its(:thumbnail_small)  { should eq 'http://b.vimeocdn.com/ts/443/595/443595474_100.jpg' }
    its(:thumbnail_medium) { should eq 'http://b.vimeocdn.com/ts/443/595/443595474_200.jpg' }
    its(:thumbnail_large)  { should eq 'http://b.vimeocdn.com/ts/443/595/443595474_640.jpg' }
    its(:videos)           { should match_array(videos) }
    its(:view_count)       { should be_nil }
  end

  context "with playlist 2755718 in embed path", :vcr do
    subject { VideoInfo.new('http://player.vimeo.com/hubnut/album/2755718') }

    its(:playlist_id) { should eq '2755718' }
  end

end
