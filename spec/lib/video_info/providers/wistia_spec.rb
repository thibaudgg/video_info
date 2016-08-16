# encoding: UTF-8
require 'spec_helper'

describe VideoInfo::Providers::Wistia do
  describe '.usable?' do
    subject { VideoInfo::Providers::Wistia.usable?(url) }

    context 'with wistia url' do
      let(:url) { 'http://fast.wistia.net/embed/iframe/rs1me54mpw' }
      it { is_expected.to be_truthy }
    end

    context 'with other url' do
      let(:url) { 'http://www.youtube.com/898029' }
      it { is_expected.to be_falsey }
    end
  end

  describe '#available?' do
    context 'with valid video', :vcr do
      video_url = 'http://fast.wistia.net/embed/iframe/rs1me54mpw'
      subject { VideoInfo.new(video_url) }

      describe '#available?' do
        subject { super().available? }
        it { is_expected.to be_truthy }
      end
    end

    context 'with invalid video', :vcr do
      subject { VideoInfo.new('http://fast.wistia.net/embed/iframe/no_video') }

      describe '#available?' do
        subject { super().available? }
        it { is_expected.to be_falsey }
      end
    end
  end

  context 'with video rs1me54mpw', :vcr do
    subject { VideoInfo.new('http://fast.wistia.net/embed/iframe/rs1me54mpw') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq 'Wistia' }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq 'rs1me54mpw' }
    end

    describe '#url' do
      subject { super().url }
      it { is_expected.to eq 'http://fast.wistia.net/embed/iframe/rs1me54mpw' }
    end

    describe '#embed_url' do
      subject { super().embed_url }
      it { is_expected.to eq '//fast.wistia.net/embed/iframe/rs1me54mpw' }
    end

    describe '#embed_code' do
      subject { super().embed_code }
      embed_code = '<iframe src="//fast.wistia.net/embed/iframe/rs1me54mpw" '\
                   'frameborder="0"></iframe>'
      it { is_expected.to eq embed_code }
    end

    describe '#title' do
      subject { super().title }
      it { is_expected.to eq 'Lance Kalish - Yes To Group' }
    end

    describe '#duration' do
      subject { super().duration }
      it { is_expected.to eq 1214.83 }
    end

    describe '#width' do
      subject { super().width }
      it { is_expected.to eq 960 }
    end

    describe '#height' do
      subject { super().height }
      it { is_expected.to eq 540 }
    end

    describe '#thumbnail_small' do
      subject { super().thumbnail_small }
      thumbnail_url = 'https://embed-ssl.wistia.com/deliveries/' \
                      'dc005e6a7583a25c4b7c284c08afc42fb67fdb95.jpg' \
                      '?image_crop_resized=960x540'
      it { is_expected.to eq thumbnail_url }
    end

    describe '#thumbnail_medium' do
      subject { super().thumbnail_small }
      thumbnail_url = 'https://embed-ssl.wistia.com/deliveries/' \
                      'dc005e6a7583a25c4b7c284c08afc42fb67fdb95.jpg?' \
                      'image_crop_resized=960x540'
      it { is_expected.to eq thumbnail_url }
    end

    describe '#thumbnail_large' do
      subject { super().thumbnail_small }
      thumbnail_url = 'https://embed-ssl.wistia.com/deliveries/' \
                      'dc005e6a7583a25c4b7c284c08afc42fb67fdb95.jpg' \
                      '?image_crop_resized=960x540'
      it { is_expected.to eq thumbnail_url }
    end

    describe '#thumbnail' do
      subject { super().thumbnail }
      thumbnail_url = 'https://embed-ssl.wistia.com/deliveries/' \
                      'dc005e6a7583a25c4b7c284c08afc42fb67fdb95.jpg' \
                      '?image_crop_resized=960x540'
      it { is_expected.to eq thumbnail_url }
    end
  end

  context 'with video pxonqr42is', :vcr do
    subject { VideoInfo.new('http://fast.wistia.com/embed/medias/pxonqr42is') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq 'Wistia' }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq 'pxonqr42is' }
    end

    describe '#url' do
      subject { super().url }
      it { is_expected.to eq 'http://fast.wistia.com/embed/medias/pxonqr42is' }
    end

    describe '#embed_url' do
      subject { super().embed_url }
      it { is_expected.to eq '//fast.wistia.net/embed/iframe/pxonqr42is' }
    end

    describe '#embed_code' do
      subject { super().embed_code }
      embed_code = '<iframe src="//fast.wistia.net/embed/iframe/pxonqr42is" ' \
                   'frameborder="0"></iframe>'
      it { is_expected.to eq embed_code }
    end

    describe '#title' do
      subject { super().title }
      it { is_expected.to eq 'Understanding Analytics' }
    end

    describe '#duration' do
      subject { super().duration }
      it { is_expected.to eq 250.0 }
    end

    describe '#width' do
      subject { super().width }
      it { is_expected.to eq 960 }
    end

    describe '#height' do
      subject { super().height }
      it { is_expected.to eq 540 }
    end

    describe '#thumbnail_small' do
      subject { super().thumbnail_small }
      thumbnail_url = 'https://embed-ssl.wistia.com/deliveries/' \
                      '0fccbdc60ade35723f79f1c002bc61b135b610fa.jpg' \
                      '?image_crop_resized=960x540'
      it { is_expected.to eq thumbnail_url }
    end

    describe '#thumbnail_medium' do
      subject { super().thumbnail_small }
      thumbnail_url = 'https://embed-ssl.wistia.com/deliveries/' \
                      '0fccbdc60ade35723f79f1c002bc61b135b610fa.jpg' \
                      '?image_crop_resized=960x540'
      it { is_expected.to eq thumbnail_url }
    end

    describe '#thumbnail_large' do
      subject { super().thumbnail_small }
      thumbnail_url = 'https://embed-ssl.wistia.com/deliveries/' \
                      '0fccbdc60ade35723f79f1c002bc61b135b610fa.jpg' \
                      '?image_crop_resized=960x540'
      it { is_expected.to eq thumbnail_url }
    end
  end
end
