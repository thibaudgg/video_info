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
      subject { VideoInfo.new('https://vk.com/videos39576223?z=video39576223_165607445%2Fpl_39576223_-2') }
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
      video_url = 'https://vk.com/video?z=video39576223_166315543%2Fpl_cat_updates'
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
    its(:author)           { should eq('Tanka Malesh').or(eq('Танька Малеш')) }
  end

  context 'with video videos43640822#/video43640822_168790809', :vcr do
    video_url = 'https://vk.com/videos43640822#/video43640822_168790809'
    subject { VideoInfo.new(video_url) }

    author_thumbnail = 'https://pp.vk.me/c837422/v837422822' \
                       '/93c8/00oqd-3BS9U.jpg'
    video_title = 'UDC open cup 2014/ 3 place / Saley Daria (solo)'

    its(:provider)         { should eq 'Vkontakte' }
    its(:video_owner)      { should eq '43640822' }
    its(:video_id)         { should eq '168790809' }
    its(:title)            { should eq video_title }
    its(:author)           { should eq('Dasha Saley').or(eq('Даша Салей')) }
    its(:author_thumbnail) { should eq author_thumbnail }
    its(:author_url)       { should eq 'https://vk.com/videos43640822' }
  end

  context 'with video from kirill.lyanoi?z=' \
          'video2152699_168591741%2F56fd229a9dfe2dcdbe', :vcr do
    video_url = 'https://vk.com/kirill.lyanoi?' \
                'z=video2152699_168591741%2F56fd229a9dfe2dcdbe'
    subject { VideoInfo.new(video_url) }

    author_thumbnail = 'https://pp.vk.me/c623824/v623824699' \
                       '/55575/CCQZ29l0B9k.jpg'
    thumbnail_small = 'https://pp.vk.me/c617831/u96123303/video/l_27e4ff5c.jpg'
    description_text = 'BEAT SOUL STEP ★ Project818 Russian ' \
                       'Dance Championship ★ 1-2 мая, Москва 2014'
    video_title = 'BEAT SOUL STEP — RDC14 Project818 Russian ' \
                  'Dance Championship, May 1-2, Moscow 2014'
    embed_code = '<iframe src="//vk.com/video_ext.php?oid=2152699' \
                 '&id=168591741&hash=ea1d3db98818125d" frameborder="0" ' \
                 'allowfullscreen="allowfullscreen"></iframe>'
    embed_url = '//vk.com/video_ext.php?oid=2152699&id=168591741' \
                '&hash=ea1d3db98818125d'
    author = 'Kirill Lyanoy'
    author_alt = 'Кирилл Льяной'

    its(:provider)         { should eq 'Vkontakte' }
    its(:video_owner)      { should eq '2152699' }
    its(:video_id)         { should eq '168591741' }
    its(:url)              { should eq video_url }
    its(:embed_url)        { should eq embed_url }
    its(:embed_code)       { should eq embed_code }
    its(:title)            { should eq video_title }
    its(:description)      { should start_with description_text }
    its(:keywords)         { should be_nil }
    its(:duration)         { should eq 299 }
    its(:width)            { should eq 960 }
    its(:height)           { should eq 540 }
    its(:view_count)       { should be > 10 }
    its(:author)           { should eq(author).or(eq(author_alt)) }
    its(:author_thumbnail) { should eq author_thumbnail }
    its(:author_url)       { should eq 'https://vk.com/videos2152699' }
    its(:thumbnail)        { should be_nil }
    its(:thumbnail_small)  { should eq thumbnail_small }
  end

  context 'with video video39576223_161598544', :vcr do
    subject { VideoInfo.new('https://vk.com/video39576223_161598544') }

    title_text = 'Harry Partridge - Skyrim (русская озвучка)'
    description_text = 'Тут могло быть описание'
    embed_url = '//vk.com/video_ext.php?oid=39576223&' \
                'id=161598544&hash=f7140d579b7f53e4'
    embed_code = '<iframe src="//vk.com/video_ext.php?oid=39576223' \
                 '&id=161598544&hash=f7140d579b7f53e4" frameborder="0"' \
                 ' allowfullscreen="allowfullscreen"></iframe>'

    its(:provider)     { should eq 'Vkontakte' }
    its(:video_owner)  { should eq '39576223' }
    its(:video_id)     { should eq '161598544' }
    its(:url)          { should eq 'https://vk.com/video39576223_161598544' }
    its(:embed_url)    { should eq embed_url }
    its(:embed_code)   { should eq embed_code }
    its(:title)        { should eq title_text }
    its(:description)  { should eq description_text }
    its(:keywords)     { should be_nil }
    its(:duration)     { should eq 85 }
    its(:width)        { should eq 960 }
    its(:height)       { should eq 540 }
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

  context 'with video video3552522_171340713', :vcr do
    subject { VideoInfo.new('http://vk.com/video3552522_171340713') }

    embed_url = '//vk.com/video_ext.php?oid=3552522&id=171340713' \
                '&hash=9826caf9bf171494'

    its(:embed_url) { should eq embed_url }
  end
end
