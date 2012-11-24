require 'spec_helper'

describe "Vimeo" do
  describe "video info" do
    use_vcr_cassette "vimeo/898029"
    subject { VideoInfo.new('http://www.vimeo.com/898029') }

    it                     { should be_valid }
    its(:provider)         { should == 'Vimeo' }
    its(:video_id)         { should == '898029' }
    its(:url)              { should == 'http://vimeo.com/898029' }
    its(:embed_url)        { should == 'http://player.vimeo.com/video/898029' }
    its(:embed_code)       { should == '<iframe src="http://player.vimeo.com/video/898029?title=0&amp;byline=0&amp;portrait=0&amp;autoplay=0" frameborder="0"></iframe>' }
    its(:title)            { should == 'Cherry Bloom - King Of The Knife' }
    its(:description)      { should == 'The first video from the upcoming album Secret Sounds, to download in-stores April 14. Checkout http://www.cherrybloom.net' }
    its(:keywords)         { should == 'cherry bloom, secret sounds, king of the knife, rock, alternative' }
    its(:duration)         { should == 175 }
    its(:width)            { should == 640 }
    its(:height)           { should == 360 }
    its(:date)             { should == Time.parse('2008-04-14 13:10:39', Time.now.utc) }
    its(:thumbnail_small)  { should == 'http://b.vimeocdn.com/ts/343/731/34373130_100.jpg' }
    its(:thumbnail_medium) { should == 'http://b.vimeocdn.com/ts/343/731/34373130_200.jpg' }
    its(:thumbnail_large)  { should == 'http://b.vimeocdn.com/ts/343/731/34373130_640.jpg' }
    its(:view_count)       { should be > 4000 }
  end

  describe "/group/ url" do
    use_vcr_cassette "vimeo/898029"
    subject { VideoInfo.new('http://vimeo.com/groups/1234/videos/898029') }

    its(:provider) { should == 'Vimeo' }
  end

  describe "bad vimeo url" do
    subject { VideoInfo.new('http://www.vimeo.com/groups/898029') }

    it { should_not be_valid }
  end

  describe "iframe attributes vimeo" do
    use_vcr_cassette "vimeo/898029"
    subject { VideoInfo.new('http://vimeo.com/groups/1234/videos/898029', :iframe_attributes => { :width => 800, :height => 600 } ) }

    its(:embed_code) { should match(/width="800"/) }
    its(:embed_code) { should match(/height="600"/) }
  end
end
