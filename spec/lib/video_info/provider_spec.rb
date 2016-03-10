require 'spec_helper'

describe VideoInfo::Provider do
  class ProviderFu < VideoInfo::Provider
    def _url_regex
      %r{foo\/(\d)}
    end

    def embed_url
      '//foo.com'
    end

    def _default_url_attributes; {} end

    def _default_iframe_attributes; {} end
  end
  let(:url) { 'url' }
  let(:options) { {} }
  let(:provider) { ProviderFu.new('foo/1', options) }

  describe 'initialize' do
    it 'should raise error if #_url_regex is not implemented' do
      error_msg = 'Provider class must implement #_url_regex private method'
      expected = expect { VideoInfo::Provider.new(url) }
      expected.to raise_error(NotImplementedError, error_msg)
    end

    it 'should raise error if #_api_url is not implemented' do
      api_url_error_msg = 'Provider class must implement ' \
                          '#_api_url private method'
      expected = expect { provider.data }
      expected.to raise_error(NotImplementedError, api_url_error_msg)
    end

    it 'sets default user_agent options' do
      user_agent_hash = { 'User-Agent' => "VideoInfo/#{VideoInfo::VERSION}" }
      expect(provider.options).to eq(user_agent_hash)
    end

    context 'with custom User-Agent options' do
      let(:options) { { 'User-Agent' => 'Test User Agent / 1.0' } }

      it 'sets the option' do
        expect(provider.options).to eq('User-Agent' => 'Test User Agent / 1.0')
      end
    end

    context 'with Referer options' do
      let(:options) { { referer: 'http://google.com' } }

      it 'sets the option' do
        expect(provider.options).to include('Referer' => 'http://google.com')
      end
    end
  end

  describe 'embed_code' do
    it 'supports url_attributes option' do
      embed_str = '<iframe src="//foo.com?foo=bar" frameborder="0"></iframe>'
      expected = expect(provider.embed_code(url_attributes: { foo: 'bar' }))
      expected.to eq embed_str
    end

    it 'supports url_attributes option' do
      embed_str = '<iframe src="//foo.com" frameborder="0" foo="bar"></iframe>'
      expected = expect(provider.embed_code(iframe_attributes: { foo: 'bar' }))
      expected.to eq embed_str
    end
  end

  describe '.usable?' do
    it 'should raise eror if not usable' do
      error_msg = 'Provider class must implement .usable? public method'
      expected = expect do
        VideoInfo::Provider.usable?('url')
      end
      expected.to raise_error(NotImplementedError, error_msg)
    end
  end
end
