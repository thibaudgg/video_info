# encoding: UTF-8
require 'spec_helper'
require 'webmock/rspec'

describe VideoInfo::Providers::Vkontakte do
  describe '.usable?' do
    subject { VideoInfo::Providers::Vkontakte.usable?(url) }

    context 'with vkontakte url' do
      context 'old style', :vcr do
        let(:url) { 'http://vk.com/video39576223_108370515' }
        it { should be_truthy }
      end

      context 'new style', :vcr do
        let(:url) do
          'https://vk.com/kirill.lyanoi?z=video2152699' \
          '_168591741%2F56fd229a9dfe2dcdbe'
        end
        it { should be_truthy }
      end
    end

    context 'with other url' do
      let(:url) { 'http://www.youtube.com/898029' }
      it { should be_falsey }
    end

    context 'with invalid url' do
      let(:url) { 'http://vk.com just random data' }
      it { should be_falsey }
    end

    context 'with spaces at end' do
      let(:url) { 'http://vk.com/video39576223_108370515        ' }
      it { should be_truthy }
    end

    context 'with spaces at start' do
      let(:url) { '      http://vk.com/video39576223_108370515' }
      it { should be_truthy }
    end

    context 'with spaces around url' do
      let(:url) { '      http://vk.com/video39576223_108370515      ' }
      it { should be_truthy }
    end
  end

  describe '#available?' do
    context 'with valid video', :vcr do
      subject { VideoInfo.new('http://vk.com/video39576223_108370515') }
      its(:available?) { should be_truthy }
    end

    context 'with invalid video', :vcr do
      subject { VideoInfo.new('http://vk.com/video39576223_invalid') }
      its(:available?) { should be_falsey }
    end

    context 'with private video', :vcr do
      subject { VideoInfo.new('http://vk.com/video39576223_166315543') }
      its(:available?) { should be_falsey }
    end

    context 'with redirect', :vcr do
      video_url = 'http://vk.com/polinka_zh?z=' \
                  'video186965901_168185427%2Fbfb2bd2e674031520a'
      subject { VideoInfo.new(video_url) }
      its(:available?) { should be_truthy }
    end

    context 'with redirect to main page for auth', :vcr do
      video_url = 'http://vk.com/video?z=video1472940_169081944%2Falbum1472940'
      subject { VideoInfo.new(video_url) }
      its(:available?) { should be_falsey }
    end

    context 'with hashes', :vcr do
      video_url = 'https://vk.com/videos43640822#/video43640822_168790809'
      subject { VideoInfo.new(video_url) }
      its(:available?) { should be_truthy }
    end
  end

  context 'with video https://vk.com/id44052340?z=' \
          'video61291456_159590018%2F2521d92730a272a9ea', :vcr do
    video_url = 'https://vk.com/id44052340?z=' \
                'video61291456_159590018%2F2521d92730a272a9ea'

    subject { VideoInfo.new(video_url) }

    embed_code = '<iframe src="//vk.com/video_ext.php?oid=61291456&' \
                 'id=159590018&hash=68174b2af560c54c" frameborder="0" ' \
                 'allowfullscreen="allowfullscreen"></iframe>'
    embed_url = '//vk.com/video_ext.php?oid=61291456&' \
                'id=159590018&hash=68174b2af560c54c'

    its(:provider)         { should eq 'Vkontakte' }
    its(:video_owner)      { should eq '61291456' }
    its(:video_id)         { should eq '159590018' }
    its(:title)            { should eq 'Happy Birthday To You' }
    its(:embed_url)        { should eq embed_url }
    its(:embed_code)       { should eq embed_code }
    its(:author)           { should eq 'Tanka Malesh' }
  end

  context 'with video videos43640822#/video43640822_168790809', :vcr do
    video_url = 'https://vk.com/videos43640822#/video43640822_168790809'
    subject { VideoInfo.new(video_url) }

    author_thumbnail = 'https://pp.vk.me/c633618/v633618822/' \
                       '1171b/Tm_TYkMxFww.jpg'
    video_title = 'UDC open cup 2014/ 3 place / Saley Daria (solo)'

    its(:provider)         { should eq 'Vkontakte' }
    its(:video_owner)      { should eq '43640822' }
    its(:video_id)         { should eq '168790809' }
    its(:title)            { should eq video_title }
    its(:author)           { should eq 'Dasha Saley' }
    its(:author_thumbnail) { should eq author_thumbnail }
    its(:author_url)       { should eq 'https://vk.com/dariasaley' }
  end

  context 'with video from kirill.lyanoi?z=' \
          'video2152699_168591741%2F56fd229a9dfe2dcdbe', :vcr do
    video_url = 'https://vk.com/kirill.lyanoi?' \
                'z=video2152699_168591741%2F56fd229a9dfe2dcdbe'
    subject { VideoInfo.new(video_url) }

    author_thumbnail = 'https://pp.vk.me/c623824/v623824699' \
                       '/55575/CCQZ29l0B9k.jpg'
    description_text = 'BEAT SOUL STEP ★ Project818 Russian ' \
                       'Dance Championship ★ 1-2 мая, Москва 2014'
    video_title = 'BEAT SOUL STEP — RDC14 Project818 Russian ' \
                  'Dance Championship, May 1-2, Moscow 2014'
    embed_code = '<iframe src="//vk.com/video_ext.php?oid=2152699&' \
                 'id=168591741&hash=" frameborder="0" allowfullscreen=' \
                 '"allowfullscreen"></iframe>'
    embed_url = '//vk.com/video_ext.php?oid=2152699&id=168591741&hash='

    its(:provider)         { should eq 'Vkontakte' }
    its(:video_owner)      { should eq '2152699' }
    its(:video_id)         { should eq '168591741' }
    its(:url)              { should eq video_url }
    its(:embed_url)        { should eq embed_url }
    its(:embed_code)       { should eq embed_code }
    its(:title)            { should eq video_title }
    its(:description)      { should start_with description_text }
    its(:keywords)         { should start_with description_text }
    its(:duration)         { should eq 299 }
    its(:width)            { should eq 0 }
    its(:height)           { should eq 0 }
    its(:view_count)       { should be > 10 }
    its(:author)           { should eq 'Kirill Lyanoy' }
    its(:author_thumbnail) { should eq author_thumbnail }
    its(:author_url)       { should eq 'https://vk.com/lyanoi.kirill' }
  end

  context 'with video video39576223_108370515', :vcr do
    subject { VideoInfo.new('http://vk.com/video39576223_108370515') }

    description_text = 'это ВЗРЫВ МОЗГА!!!<br>Просто отвал башки...'
    keywords = 'это ВЗРЫВ МОЗГА!!!<br>Просто отвал башки...'
    embed_url = '//vk.com/video_ext.php?oid=39576223&' \
                'id=108370515&hash=15184dbd085c47af'
    embed_code = '<iframe src="//vk.com/video_ext.php?oid=39576223&' \
                 'id=108370515&hash=15184dbd085c47af" frameborder="0" ' \
                 'allowfullscreen="allowfullscreen"></iframe>'

    its(:provider)     { should eq 'Vkontakte' }
    its(:video_owner)  { should eq '39576223' }
    its(:video_id)     { should eq '108370515' }
    its(:url)          { should eq 'http://vk.com/video39576223_108370515' }
    its(:embed_url)    { should eq embed_url }
    its(:embed_code)   { should eq embed_code }
    its(:title)        { should eq 'Я уточка)))))' }
    its(:description)  { should eq description_text }
    its(:keywords)     { should eq keywords }
    its(:duration)     { should eq 183 }
    its(:width)        { should eq 320 }
    its(:height)       { should eq 240 }
    its(:view_count)   { should be > 10 }
  end

  context 'with video video-54799401_165822734', :vcr do
    subject { VideoInfo.new('http://vk.com/video-54799401_165822734') }

    its(:provider)     { should eq 'Vkontakte' }
    its(:video_owner)  { should eq '-54799401' }
    its(:video_id)     { should eq '165822734' }
    its(:title)        { should eq 'SpaceGlasses are the future of computing' }
  end

  context 'with valid video and connection timeout' do
    subject { VideoInfo.new('http://vk.com/video-54799401_165822734') }

    describe '#title' do
      before do
        stub_request(:any, /.*vk.com.*/).to_timeout
      end

      it 'raises VideoInfo::HttpError exception' do
        expect { subject.title }.to raise_error VideoInfo::HttpError
      end
    end
  end

  context 'with valid video and OpenURI::HTTPError exception' do
    subject { VideoInfo.new('http://vk.com/video-54799401_165822734') }

    describe '#title' do
      before do
        stub = stub_request(:any, /.*vk.com.*/)
        stub.to_raise(OpenURI::HTTPError.new('error', :nop))
      end

      it 'raises VideoInfo::HttpError exception' do
        expect { subject.title }.to raise_error VideoInfo::HttpError
      end
    end
  end
end
