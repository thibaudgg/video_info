# encoding: utf-8
require 'spec_helper'

describe VideoInfo::Providers::Dailymotion do

  describe ".usable?" do
    subject { VideoInfo::Providers::Dailymotion.usable?(url) }

    context "with dailymotion url" do
      let(:url) { 'http://www.dailymotion.com/video/x7lni3' }
      it { is_expected.to be_truthy }
    end

    context "with dai.ly url" do
      let(:url) { 'http://dai.ly/video/x7lni3' }
      it { is_expected.to be_truthy }
    end

    context "with other url" do
      let(:url) { 'http://www.youtube.com/x7lni3' }
      it { is_expected.to be_falsey }
    end
  end

  describe "#available?" do
    context "with valid video", :vcr do
      subject { VideoInfo.new('http://www.dailymotion.com/video/x7lni3') }

      describe '#available?' do
        subject { super().available? }
        it { is_expected.to be_truthy }
      end
    end

    context "with 'This video does not exist or has been deleted.", :vcr do
      subject { VideoInfo.new('http://www.dailymotion.com/video/inValIdiD') }

      describe '#available?' do
        subject { super().available? }
        it { is_expected.to be_falsey }
      end
    end
  end

  context "with video x7lni3", :vcr do
    subject { VideoInfo.new('http://www.dailymotion.com/video/x7lni3') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq 'Dailymotion' }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq 'x7lni3' }
    end

    describe '#url' do
      subject { super().url }
      it { is_expected.to eq 'http://www.dailymotion.com/video/x7lni3' }
    end

    describe '#embed_url' do
      subject { super().embed_url }
      it { is_expected.to eq '//www.dailymotion.com/embed/video/x7lni3' }
    end

    describe '#embed_code' do
      subject { super().embed_code }
      it { is_expected.to eq '<iframe src="//www.dailymotion.com/embed/video/x7lni3?autoplay=0" frameborder="0"></iframe>' }
    end

    describe '#title' do
      subject { super().title }
      it { is_expected.to eq 'Mario Kart (Rémi Gaillard)' }
    end

    describe '#description' do
      subject { super().description }
      it { is_expected.to eq 'Super Rémi Kart est un jeu vidéo de course développé et édité par N\'Importe Quoi TV. Sa principale originalité vient de sa réalité...<br />L\'aventure continue sur www.nimportequi.com' }
    end

    describe '#keywords' do
      subject { super().keywords }
      it { is_expected.to eq ["rémi","remi","gaillard","imposteur","imposture","mario","bros","kart","nintendo","jeux"] }
    end

    describe '#duration' do
      subject { super().duration }
      it { is_expected.to eq 136}
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
      it { is_expected.to eq Time.parse('2008-12-03 16:29:31 UTC', Time.now.utc) }
    end

    describe '#thumbnail_small' do
      subject { super().thumbnail_small }
      it { is_expected.to eq 'http://s2.dmcdn.net/BgWxI/x60-kbf.jpg' }
    end

    describe '#thumbnail_medium' do
      subject { super().thumbnail_medium }
      it { is_expected.to eq 'http://s2.dmcdn.net/BgWxI/x240-b83.jpg' }
    end

    describe '#thumbnail_large' do
      subject { super().thumbnail_large }
      it { is_expected.to eq 'http://s2.dmcdn.net/BgWxI/x720-YcV.jpg' }
    end

    describe '#view_count' do
      subject { super().view_count }
      it { is_expected.to be > 10000000 }
    end
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

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq 'Dailymotion' }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq 'x7lni3' }
    end
  end

end
