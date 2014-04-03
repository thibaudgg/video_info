# encoding: utf-8
require 'spec_helper'

describe VideoInfo::Providers::Dailymotion do

  describe ".usable?" do
    subject { VideoInfo::Providers::Dailymotion.usable?(url) }

    context "with dailymotion url" do
      let(:url) { 'http://www.dailymotion.com/video/x7lni3' }
      it { should be_true }
    end

    context "with dai.ly url" do
      let(:url) { 'http://dai.ly/video/x7lni3' }
      it { should be_true }
    end

    context "with other url" do
      let(:url) { 'http://www.youtube.com/x7lni3' }
      it { should be_false }
    end
  end

  describe "#available?" do
    context "with valid video", :vcr do
      subject { VideoInfo.new('http://www.dailymotion.com/video/x7lni3') }
      its(:available?)       { should be_true }
    end

    context "with 'This video does not exist or has been deleted.", :vcr do
      subject { VideoInfo.new('http://www.dailymotion.com/video/inValIdiD') }
      its(:available?)       { should be_false }
    end
  end

  context "with video x7lni3", :vcr do
    subject { VideoInfo.new('http://www.dailymotion.com/video/x7lni3') }

    its(:provider)         { should eq 'Dailymotion' }
    its(:video_id)         { should eq 'x7lni3' }
    its(:url)              { should eq 'http://www.dailymotion.com/video/x7lni3' }
    its(:embed_url)        { should eq '//www.dailymotion.com/embed/video/x7lni3' }
    its(:embed_code)       { should eq '<iframe src="//www.dailymotion.com/embed/video/x7lni3?autoplay=0" frameborder="0"></iframe>' }
    its(:title)            { should eq 'Mario Kart (Rémi Gaillard)' }
    its(:description)      { should eq 'Super Rémi Kart est un jeu vidéo de course développé et édité par N\'Importe Quoi TV. Sa principale originalité vient de sa réalité...<br />L\'aventure continue sur www.nimportequi.com' }
    its(:keywords)         { should eq ["rémi","remi","gaillard","imposteur","imposture","mario","bros","kart","nintendo","jeux"] }
    its(:duration)         { should eq 136}
    its(:width)            { should be_nil }
    its(:height)           { should be_nil }
    its(:date)             { should eq Time.parse('2008-12-03 16:29:31 UTC', Time.now.utc) }
    its(:thumbnail_small)  { should eq 'http://s2.dmcdn.net/BgWxI/x60-kbf.jpg' }
    its(:thumbnail_medium) { should eq 'http://s2.dmcdn.net/BgWxI/x240-b83.jpg' }
    its(:thumbnail_large)  { should eq 'http://s2.dmcdn.net/BgWxI/x720-YcV.jpg' }
    its(:view_count)       { should be > 10000000 }
  end

  context "with video x7lni3 and url_attributes", :vcr do
    subject { VideoInfo.new('http://www.dailymotion.com/video/x7lni3') }

    it { expect(subject.embed_code(url_attributes: { autoplay: 1 })).to match(/autoplay=1/) }
  end

  context "with video x7lni3 and iframe_attributes", :vcr do
    subject { VideoInfo.new('http://www.dailymotion.com/video/x7lni3') }

    it { expect(subject.embed_code(iframe_attributes: { width: 800, height: 600 })).to match(/width="800"/) }
    it { expect(subject.embed_code(iframe_attributes: { width: 800, height: 600 })).to match(/height="600"/) }
  end

  context "with video x7lni3 in text", :vcr do
    subject { VideoInfo.new('<a href="http://www.dailymotion.com/video/x7lni3">http://www.dailymotion.com/video/x7lni3</a>') }

    its(:provider) { should eq 'Dailymotion' }
    its(:video_id) { should eq 'x7lni3' }
  end

end
