require 'spec_helper'

describe VideoInfo::Providers::Vimeo do

  describe ".usable?" do
    subject { VideoInfo::Providers::Vimeo.usable?(url) }

    context "with vimeo url" do
      let(:url) { 'http://www.vimeo.com/898029' }
      it { should be_true }
    end

    context "with other url" do
      let(:url) { 'http://www.youtube.com/898029' }
      it { should be_false }
    end
  end

  context "with video 898029", :vcr do
    subject { VideoInfo.new('http://www.vimeo.com/898029') }

    its(:provider)         { should eq 'Vimeo' }
    its(:video_id)         { should eq '898029' }
    its(:url)              { should eq 'http://www.vimeo.com/898029' }
    its(:embed_url)        { should eq 'player.vimeo.com/video/898029' }
    its(:embed_code)       { should eq '<iframe src="http://player.vimeo.com/video/898029?autoplay=0&byline=0&portrait=0&title=0" frameborder="0"></iframe>' }
    its(:title)            { should eq 'Cherry Bloom - King Of The Knife' }
    its(:description)      { should eq 'The first video from the upcoming album Secret Sounds, to download in-stores April 14. Checkout http://www.cherrybloom.net' }
    its(:keywords)         { should eq 'cherry bloom, secret sounds, king of the knife, rock, alternative' }
    its(:duration)         { should eq 175 }
    its(:width)            { should eq 640 }
    its(:height)           { should eq 360 }
    its(:date)             { should eq Time.parse('2008-04-14 13:10:39', Time.now.utc) }
    its(:thumbnail_small)  { should eq 'http://b.vimeocdn.com/ts/343/731/34373130_100.jpg' }
    its(:thumbnail_medium) { should eq 'http://b.vimeocdn.com/ts/343/731/34373130_200.jpg' }
    its(:thumbnail_large)  { should eq 'http://b.vimeocdn.com/ts/343/731/34373130_640.jpg' }
    its(:view_count)       { should be > 4000 }
  end

  context "with video 898029 and url_attributes", :vcr do
    subject { VideoInfo.new('http://www.vimeo.com/898029') }

    it { expect(subject.embed_code(url_attributes: { autoplay: 1 })).to match(/autoplay=1/) }
  end

  context "with video 898029 and iframe_attributes", :vcr do
    subject { VideoInfo.new('http://www.vimeo.com/898029') }

    it { expect(subject.embed_code(iframe_attributes: { width: 800, height: 600 })).to match(/width="800"/) }
    it { expect(subject.embed_code(iframe_attributes: { width: 800, height: 600 })).to match(/height="600"/) }
  end

  context "with video 898029 in /group/ url", :vcr do
    subject { VideoInfo.new('http://vimeo.com/groups/1234/videos/898029') }

    its(:provider) { should eq 'Vimeo' }
    its(:video_id) { should eq '898029' }
  end

  context "with video 898029 in /group/ url", :vcr do
    subject { VideoInfo.new('http://player.vimeo.com/video/898029') }

    its(:provider) { should eq 'Vimeo' }
    its(:video_id) { should eq '898029' }
  end

  context "with video 898029 in text", :vcr do
    subject { VideoInfo.new('<a href="http://www.vimeo.com/898029">http://www.vimeo.com/898029</a>') }

    its(:provider) { should eq 'Vimeo' }
    its(:video_id) { should eq '898029' }
  end

end
