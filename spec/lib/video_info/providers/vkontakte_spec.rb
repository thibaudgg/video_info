# encoding: UTF-8
require 'spec_helper'

describe VideoInfo::Providers::Vkontakte do

  describe ".usable?" do
    subject { VideoInfo::Providers::Vkontakte.usable?(url) }

    context "with vkontakte url" do
      let(:url) { 'http://vk.com/video39576223_108370515' }
      it { is_expected.to be_truthy }
    end

    context "with other url" do
      let(:url) { 'http://www.youtube.com/898029' }
      it { is_expected.to be_falsey }
    end
  end

  describe "#available?" do
    context "with valid video", :vcr do
      subject { VideoInfo.new('http://vk.com/video39576223_108370515') }

      describe '#available?' do
        subject { super().available? }
        it { is_expected.to be_truthy }
      end
    end

    context "with invalid video", :vcr do
      subject { VideoInfo.new('http://vk.com/video39576223_invalid') }

      describe '#available?' do
        subject { super().available? }
        it { is_expected.to be_falsey }
      end
    end

  end

  context "with video video39576223_108370515", :vcr do
    subject { VideoInfo.new('http://vk.com/video39576223_108370515') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq 'Vkontakte' }
    end

    describe '#video_owner' do
      subject { super().video_owner }
      it { is_expected.to eq '39576223' }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq '108370515' }
    end

    describe '#url' do
      subject { super().url }
      it { is_expected.to eq 'http://vk.com/video39576223_108370515' }
    end

    describe '#embed_url' do
      subject { super().embed_url }
      it { is_expected.to eq '//vk.com/video_ext.php?oid=39576223&id=108370515&hash=15184dbd085c47af' }
    end

    describe '#embed_code' do
      subject { super().embed_code }
      it { is_expected.to eq '<iframe src="//vk.com/video_ext.php?oid=39576223&id=108370515&hash=15184dbd085c47af" frameborder="0" allowfullscreen="allowfullscreen"></iframe>' }
    end

    describe '#title' do
      subject { super().title }
      it { is_expected.to eq 'Я уточка)))))' }
    end

    describe '#description' do
      subject { super().description }
      it { is_expected.to eq 'это ВЗРЫВ МОЗГА!!! Просто отвал башки...' }
    end

    describe '#keywords' do
      subject { super().keywords }
      it { is_expected.to eq 'это ВЗРЫВ МОЗГА!!! Просто отвал башки...' }
    end

    describe '#duration' do
      subject { super().duration }
      it { is_expected.to eq 183 }
    end

    describe '#width' do
      subject { super().width }
      it { is_expected.to eq 320 }
    end

    describe '#height' do
      subject { super().height }
      it { is_expected.to eq 240 }
    end

    describe '#view_count' do
      subject { super().view_count }
      it { is_expected.to be > 10 }
    end
  end

  context "with video video-54799401_165822734", :vcr do
    subject { VideoInfo.new('http://vk.com/video-54799401_165822734') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq 'Vkontakte' }
    end

    describe '#video_owner' do
      subject { super().video_owner }
      it { is_expected.to eq '-54799401' }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq '165822734' }
    end

    describe '#title' do
      subject { super().title }
      it { is_expected.to eq 'SpaceGlasses are the future of computing' }
    end
  end

end
