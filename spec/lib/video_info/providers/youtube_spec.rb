require 'spec_helper'
require 'webmock/rspec'

describe VideoInfo::Providers::Youtube do
  describe '.usable?' do
    subject { VideoInfo::Providers::Youtube.usable?(url) }

    context 'with youtube.com url' do
      let(:url) { 'http://www.youtube.com/watch?v=Xp6CXF' }
      it { is_expected.to be_truthy }
    end

    context 'with youtu.be url' do
      let(:url) { 'http://youtu.be/JM9NgvjjVng' }
      it { is_expected.to be_truthy }
    end

    context 'with other url' do
      let(:url) { 'http://google.com/video1' }
      it { is_expected.to be_falsey }
    end

    context 'with playlist url' do
      let(:url) { 'http://www.youtube.com/playlist?p=PLA575C81A1FBC04CF' }
      it { is_expected.to be_falsey }
    end
  end

  describe '#available?' do
    context 'with valid video', :vcr do
      subject { VideoInfo.new('http://www.youtube.com/watch?v=mZqGqE0D0n4') }

      describe '#available?' do
        subject { super().available? }
        it { is_expected.to be_truthy }
      end
    end

    context 'with valid video and invalid API key' do
      subject { VideoInfo.new('http://www.youtube.com/watch?v=mZqGqE0D0n4') }
      let(:msg) { 'your API key is probably invalid. Please verify it.' }
      before do
        VideoInfo.provider_api_keys[:youtube] = 'invalid_key'
      end

      after do
        VideoInfo.provider_api_keys[:youtube] = nil
      end

      describe '#available?' do
        it 'logs warning message to alert user about invalid API key' do
          expect(VideoInfo.logger).to receive(:warn).with(msg)
          subject.title
        end
      end
    end

    context 'with unavailable video', :vcr do
      subject { VideoInfo.new('http://www.youtube.com/watch?v=SUkXvWn1m7Q') }

      describe '#available?' do
        subject { super().available? }
        it { is_expected.to be_falsey }
      end

      describe '#provider' do
        subject { super().provider }
        it { is_expected.to eq 'YouTube' }
      end

      describe '#video_id' do
        subject { super().video_id }
        it { is_expected.to eq 'SUkXvWn1m7Q' }
      end

      describe '#url' do
        subject { super().url }
        it { is_expected.to eq 'http://www.youtube.com/watch?v=SUkXvWn1m7Q' }
      end

      describe '#embed_url' do
        subject { super().embed_url }
        it { is_expected.to eq '//www.youtube.com/embed/SUkXvWn1m7Q' }
      end

      describe '#embed_code' do
        subject { super().embed_code }
        embed_code = '<iframe src="//www.youtube.com/embed/SUkXvWn1m7Q" ' \
                     'frameborder="0" allowfullscreen="allowfullscreen">' \
                     '</iframe>'
        it { is_expected.to eq embed_code }
      end

      describe '#title' do
        subject { super().title }
        it { is_expected.to eq nil }
      end

      describe '#description' do
        subject { super().description }
        it { is_expected.to eq nil }
      end

      describe '#keywords' do
        subject { super().keywords }
        it { is_expected.to be_nil }
      end

      describe '#duration' do
        subject { super().duration }
        it { is_expected.to eq 0 }
      end

      describe '#date' do
        subject { super().date }
        it { is_expected.to eq nil }
      end

      describe '#thumbnail_small' do
        subject { super().thumbnail_small }
        thumbnail_url = 'https://i.ytimg.com/vi/SUkXvWn1m7Q/default.jpg'
        it { is_expected.to eq thumbnail_url }
      end

      describe '#thumbnail_medium' do
        subject { super().thumbnail_medium }
        thumbnail_url = 'https://i.ytimg.com/vi/SUkXvWn1m7Q/mqdefault.jpg'
        it { is_expected.to eq thumbnail_url }
      end

      describe '#thumbnail_large' do
        subject { super().thumbnail_large }
        thumbnail_url = 'https://i.ytimg.com/vi/SUkXvWn1m7Q/hqdefault.jpg'
        it { is_expected.to eq thumbnail_url }
      end

      describe '#view_count' do
        subject { super().view_count }
        it { is_expected.to be == 0 }
      end
    end

    context 'with video removed because of copyright claim', :vcr do
      subject { VideoInfo.new('http://www.youtube.com/watch?v=ffClNhwx0KU') }

      describe '#available?' do
        subject { super().available? }
        it { is_expected.to be_falsey }
      end
    end
  end

  context 'with video mZqGqE0D0n4', :vcr do
    video_url = 'http://www.youtube.com/watch?v=mZqGqE0D0n4'
    subject { VideoInfo.new(video_url) }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq 'YouTube' }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq 'mZqGqE0D0n4' }
    end

    describe '#url' do
      subject { super().url }
      it { is_expected.to eq video_url }
    end

    describe '#embed_url' do
      subject { super().embed_url }
      it { is_expected.to eq '//www.youtube.com/embed/mZqGqE0D0n4' }
    end

    describe '#embed_code' do
      subject { super().embed_code }
      embed_code = '<iframe src="//www.youtube.com/embed/mZqGqE0D0n4" ' \
                   'frameborder="0" allowfullscreen="allowfullscreen">' \
                   '</iframe>'
      it { is_expected.to eq embed_code }
    end

    describe '#title' do
      subject { super().title }
      it { is_expected.to eq 'Cherry Bloom - King Of The Knife' }
    end

    describe '#description' do
      subject { super().description }
      description_text = 'The first video from the upcoming album ' \
                         'Secret Sounds, to download in-stores April 14. ' \
                         'Checkout http://www.cherrybloom.net'
      it { is_expected.to eq description_text }
    end

    describe '#keywords' do
      subject { super().keywords }
      keywords_list = %w(cherry bloom king of the knife guitar
                         drum clip rock alternative tremplin Paris-Forum)
      it { is_expected.to eq keywords_list }
    end

    describe '#duration' do
      subject { super().duration }
      it { is_expected.to eq 176 }
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
      it { is_expected.to eq Time.parse('Sat Apr 12 2008', Time.now.utc) }
    end

    describe '#thumbnail_small' do
      subject { super().thumbnail_small }
      thumbnail_url = 'https://i.ytimg.com/vi/mZqGqE0D0n4/default.jpg'
      it { is_expected.to eq thumbnail_url }
    end

    describe '#thumbnail_medium' do
      subject { super().thumbnail_medium }
      thumbnail_url = 'https://i.ytimg.com/vi/mZqGqE0D0n4/mqdefault.jpg'
      it { is_expected.to eq thumbnail_url }
    end

    describe '#thumbnail_large' do
      subject { super().thumbnail_large }
      thumbnail_url = 'https://i.ytimg.com/vi/mZqGqE0D0n4/hqdefault.jpg'
      it { is_expected.to eq thumbnail_url }
    end

    describe '#view_count' do
      subject { super().view_count }
      it { is_expected.to be > 4000 }
    end

    describe '#author' do
      subject { super().author }
      it { is_expected.to eql 'Cherry Bloom' }
    end

    describe '#author_thumbnail' do
      subject { super().author_thumbnail }
      author_thumbnail = 'https://yt3.ggpht.com/-7rhnfdQaI3k/AAAAAAAAAAI/' \
                         'AAAAAAAAAAA/eMJZ5HBukCQ/s88-c-k-no/photo.jpg'
      it { is_expected.to eql author_thumbnail }
    end

    describe '#author_url' do
      subject { super().author_url }
      author_url = 'https://www.youtube.com/channel/UCzxQk-rZGowoqMBKxGD5jSA'
      it { is_expected.to eql author_url }
    end
  end

  context 'with video oQ49W_xKzKA', :vcr do
    video_url = 'http://www.youtube.com/watch?v=oQ49W_xKzKA'
    subject { VideoInfo.new(video_url) }

    it 'should contain autoplay attribute' do
      expected = expect(subject.embed_code(url_attributes: { autoplay: 1 }))
      expected.to match(/autoplay=1/)
    end
  end

  context 'with video oQ49W_xKzKA', :vcr do
    video_url = 'http://www.youtube.com/watch?v=oQ49W_xKzKA'
    subject { VideoInfo.new(video_url) }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq 'YouTube' }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq 'oQ49W_xKzKA' }
    end
  end

  context 'with video Xp6CXF-Cesg', :vcr do
    subject { VideoInfo.new('http://www.youtube.com/watch?v=Xp6CXF-Cesg') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq 'YouTube' }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq 'Xp6CXF-Cesg' }
    end
  end

  context 'with video VeasFckfMHY in user url', :vcr do
    video_url = 'http://www.youtube.com/user/EducatorVids3?v=VeasFckfMHY'
    subject { VideoInfo.new(video_url) }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq 'YouTube' }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq 'VeasFckfMHY' }
    end

    describe '#url' do
      subject { super().url }
      it { is_expected.to eq video_url }
    end
  end

  context 'with video VeasFckfMHY after params', :vcr do
    video_url = 'http://www.youtube.com/watch?feature=player_profilepage&v=VeasFckfMHY'
    subject { VideoInfo.new(video_url) }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq 'YouTube' }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq 'VeasFckfMHY' }
    end

    describe '#url' do
      subject { super().url }
      it { is_expected.to eq video_url }
    end
  end

  context 'with video VeasFckfMHY in path', :vcr do
    subject { VideoInfo.new('http://www.youtube.com/v/VeasFckfMHY') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq 'YouTube' }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq 'VeasFckfMHY' }
    end
  end

  context 'with video VeasFckfMHY in e path', :vcr do
    subject { VideoInfo.new('http://www.youtube.com/e/VeasFckfMHY') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq 'YouTube' }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq 'VeasFckfMHY' }
    end
  end

  context 'with video VeasFckfMHY in embed path', :vcr do
    subject { VideoInfo.new('http://www.youtube.com/embed/VeasFckfMHY') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq 'YouTube' }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq 'VeasFckfMHY' }
    end
  end

  context 'with video JM9NgvjjVng in youtu.be url', :vcr do
    subject { VideoInfo.new('http://youtu.be/JM9NgvjjVng') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq 'YouTube' }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq 'JM9NgvjjVng' }
    end
  end

  context 'without http or www', :vcr do
    subject { VideoInfo.new('youtu.be/JM9NgvjjVng') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq('YouTube') }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq 'JM9NgvjjVng' }
    end
  end

  context 'with video url in text', :vcr do
    url_in_text = '<a href="http://www.youtube.com/watch?v=mZqGqE0D0n4">' \
                  'http://www.youtube.com/watch?v=mZqGqE0D0n4</a>'

    subject { VideoInfo.new(url_in_text) }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq('YouTube') }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq('mZqGqE0D0n4') }
    end
  end

  context 'with iframe attributes', :vcr do
    subject { VideoInfo.new('http://www.youtube.com/watch?v=mZqGqE0D0n4') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq('YouTube') }
    end

    it 'should apply width and height attributes properly' do
      dimensions = { width: 800, height: 600 }
      expected = expect(subject.embed_code(iframe_attributes: dimensions))
      expected.to match(/width="800"/)
      expected.to match(/height="600"/)
    end
  end

  context 'with arbitrary iframe_attributes', :vcr do
    subject { VideoInfo.new('http://www.youtube.com/watch?v=mZqGqE0D0n4') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq('YouTube') }
    end
    it 'should apply arbitrary iframe attributes' do
      attributes = { :'data-colorbox' => true }
      expected = expect(subject.embed_code(iframe_attributes: attributes))
      expected.to match(/data-colorbox="true"/)
    end
  end

  context 'URL without http:// or https://' do
    subject { VideoInfo.new('www.youtube.com/watch?v=ylTY9WbMGDc') }

    describe '#title' do
      subject { super().title }
      it { is_expected.to eq 'Deafheaven - Sunbather' }
    end
  end

  context 'with full screen video URLs', :vcr do
    video_url = 'http://www.youtube.com/v/mZqGqE0D0n4'
    subject { VideoInfo.new(video_url) }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq 'YouTube' }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq 'mZqGqE0D0n4' }
    end

    describe '#url' do
      subject { super().url }
      it { is_expected.to eq video_url }
    end

    describe '#embed_url' do
      subject { super().embed_url }
      it { is_expected.to eq '//www.youtube.com/embed/mZqGqE0D0n4' }
    end

    describe '#embed_code' do
      subject { super().embed_code }
      embed_code = '<iframe src="//www.youtube.com/embed/mZqGqE0D0n4" ' \
                   'frameborder="0" allowfullscreen="allowfullscreen">' \
                   '</iframe>'
      it { is_expected.to eq embed_code }
    end

    describe '#title' do
      subject { super().title }
      it { is_expected.to eq 'Cherry Bloom - King Of The Knife' }
    end

    describe '#description' do
      subject { super().description }
      description = 'The first video from the upcoming album Secret Sounds, ' \
                    'to download in-stores April 14. ' \
                    'Checkout http://www.cherrybloom.net'
      it { is_expected.to eq description }
    end

    describe '#keywords' do
      subject { super().keywords }
      keywords_list = %w(cherry bloom king of the knife guitar
                         drum clip rock alternative tremplin Paris-Forum)
      it { is_expected.to eq keywords_list }
    end

    describe '#duration' do
      subject { super().duration }
      it { is_expected.to eq 176 }
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
      it { is_expected.to eq Time.parse('Sat Apr 12 2008', Time.now.utc) }
    end

    describe '#thumbnail_small' do
      subject { super().thumbnail_small }
      thumbnail_url = 'https://i.ytimg.com/vi/mZqGqE0D0n4/default.jpg'
      it { is_expected.to eq thumbnail_url }
    end

    describe '#thumbnail_medium' do
      subject { super().thumbnail_medium }
      thumbnail_url = 'https://i.ytimg.com/vi/mZqGqE0D0n4/mqdefault.jpg'
      it { is_expected.to eq thumbnail_url }
    end

    describe '#thumbnail_large' do
      subject { super().thumbnail_large }
      thumbnail_url = 'https://i.ytimg.com/vi/mZqGqE0D0n4/hqdefault.jpg'
      it { is_expected.to eq thumbnail_url }
    end

    describe '#view_count' do
      subject { super().view_count }
      it { is_expected.to be > 4000 }
    end
  end

  context 'with full screen video URLs with params', :vcr do
    video_url = 'https://www.youtube.com/v/ylTY9WbMGDc?someParam=foo'
    subject { VideoInfo.new(video_url) }

    describe '#title' do
      subject { super().title }
      it { is_expected.to eq 'Deafheaven - Sunbather' }
    end
  end

  context 'with valid video and connection timeout' do
    video_url = 'https://www.youtube.com/watch?v=lExm5LELpP4'
    subject { VideoInfo.new(video_url) }

    describe '#title' do
      before do
        stub = stub_request(:get, video_url)
        @stubbed = stub.to_timeout
      end

      after do
        remove_request_stub(@stubbed) if @stubbed
      end

      it 'raises VideoInfo::HttpError exception' do
        expect { subject.title }.to raise_error VideoInfo::HttpError
      end
    end
  end

  context 'with valid video and OpenURI::HTTPError exception' do
    video_url = 'https://www.youtube.com/watch?v=lExm5LELpP4'
    subject { VideoInfo.new(video_url) }

    describe '#title' do
      before do
        stub = stub_request(:get, video_url)
        stub.to_raise(OpenURI::HTTPError.new('error', :nop))
      end

      it 'raises VideoInfo::HttpError exception' do
        expect { subject.title }.to raise_error VideoInfo::HttpError
      end
    end
  end
end
