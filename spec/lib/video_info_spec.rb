require 'spec_helper'

describe VideoInfo do
  describe '#initialize' do
    let(:url) { 'url' }
    let(:options) { { foo: :bar } }
    let(:provider) { double('provider', provider: 'Provider') }

    it 'uses the first usable provider' do
      allow(VideoInfo::Providers::Vimeo).to receive(:usable?) { false }
      allow(VideoInfo::Providers::Vkontakte).to receive(:usable?) { false }
      allow(VideoInfo::Providers::Youtube).to receive(:usable?) { true }
      allow(VideoInfo::Providers::Youtube).to receive(:new) { provider }

      expect(VideoInfo.new(url, options).provider).to eq 'Provider'
    end

    it 'raise when no providers are usable' do
      allow(VideoInfo::Providers::Vimeo).to receive(:usable?) { false }
      allow(VideoInfo::Providers::Vkontakte).to receive(:usable?) { false }
      allow(VideoInfo::Providers::Youtube).to receive(:usable?) { false }

      expect { VideoInfo.new(url, options) }.to raise_error(VideoInfo::UrlError)
    end
  end

  describe '.disable_providers' do
    let(:youtube_url) { 'https://www.youtube.com/watch?v=mZqGqE0D0n4' }
    let(:vimeo_url) { 'http://vimeo.com/86701482' }

    it 'does not attempt to use a provider marked as disabled' do
      VideoInfo.disable_providers = %w[YouTube Vimeo]

      expect { VideoInfo.new(youtube_url) }.to raise_error(VideoInfo::UrlError)
      expect { VideoInfo.new(vimeo_url) }.to raise_error(VideoInfo::UrlError)

      VideoInfo.disable_providers = []
    end

    it 'is case insensitive' do
      VideoInfo.disable_providers = %w[youTUBe VIMEO]

      expect { VideoInfo.new(youtube_url) }.to raise_error(VideoInfo::UrlError)
      expect { VideoInfo.new(vimeo_url) }.to raise_error(VideoInfo::UrlError)

      VideoInfo.disable_providers = []
    end
  end

  describe '.usable?' do
    let(:url) { 'url' }
    let(:provider) { double('provider', new: true) }

    it 'returns true when a provider is usable' do
      allow(VideoInfo::Providers::Vimeo).to receive(:usable?) { false }
      allow(VideoInfo::Providers::Vkontakte).to receive(:usable?) { false }
      allow(VideoInfo::Providers::Youtube).to receive(:usable?) { true }
      allow(VideoInfo::Providers::Youtube).to receive(:new) { true }

      expect(VideoInfo.usable?(url)).to be_truthy
    end

    it 'returns false when no providers are usable' do
      allow(VideoInfo::Providers::Vimeo).to receive(:usable?) { false }
      allow(VideoInfo::Providers::Vkontakte).to receive(:usable?) { false }
      allow(VideoInfo::Providers::Youtube).to receive(:usable?) { false }

      expect(VideoInfo.usable?(url)).to be_falsey
    end
  end

  describe '.provider_api_keys' do
    it 'raises an error if key is not a symbol' do
      expected_error = expect do
        VideoInfo.provider_api_keys = { 'Youtube' => 'key' }
      end

      expected_error.to raise_error(ArgumentError)

      expected = expect do
        VideoInfo.provider_api_keys = { youtube: 'key' }
      end

      expected.to_not raise_error
    end
  end

  describe '#==' do
    let(:vi_a) { VideoInfo.new('http://www.youtube.com/watch?v=AT_5xOGh6Ko') }
    let(:vi_b) { VideoInfo.new('http://www.youtube.com/watch?v=AT_5xOGh6Ko') }
    let(:vi_c) { VideoInfo.new('http://vimeo.com/86701482') }

    context 'matching' do
      it 'returns true' do
        expect(vi_a == vi_b).to be_truthy
      end
    end

    context 'not matching' do
      it 'returns false' do
        expect(vi_a == vi_c).to be_falsey
        expect(vi_b == vi_c).to be_falsey
      end
    end
  end
end
