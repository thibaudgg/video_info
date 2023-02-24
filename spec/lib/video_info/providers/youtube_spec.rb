[nil, ENV["YOUTUBE_API_KEY"] || "youtube_api_key_123"].each do |api_key|
  describe VideoInfo::Providers::Youtube, :vcr do
    before(:all) do
      VideoInfo.provider_api_keys = {youtube: api_key}
    end

    describe ".usable?" do
      subject { VideoInfo::Providers::Youtube.usable?(url) }

      context "with youtube.com url" do
        let(:url) { "http://www.youtube.com/watch?v=Xp6CXF" }
        it { is_expected.to be_truthy }
      end

      context "with youtu.be url" do
        let(:url) { "http://youtu.be/JM9NgvjjVng" }
        it { is_expected.to be_truthy }
      end

      context "with other url" do
        let(:url) { "http://google.com/video1" }
        it { is_expected.to be_falsey }
      end

      context "with playlist url" do
        let(:url) { "http://www.youtube.com/playlist?p=PLA575C81A1FBC04CF" }
        it { is_expected.to be_falsey }
      end
    end

    describe "#available?" do
      context "with valid video" do
        subject { VideoInfo.new("http://www.youtube.com/watch?v=mZqGqE0D0n4") }

        describe "#available?" do
          subject { super().available? }
          it { is_expected.to be_truthy }
        end
      end

      context "with unavailable video" do
        subject { VideoInfo.new("http://www.youtube.com/watch?v=SUkXvWn1m7Q") }

        describe "#available?" do
          subject { super().available? }
          it { is_expected.to be_falsey }
        end

        describe "#provider" do
          subject { super().provider }
          it { is_expected.to eq "YouTube" }
        end

        describe "#video_id" do
          subject { super().video_id }
          it { is_expected.to eq "SUkXvWn1m7Q" }
        end

        describe "#url" do
          subject { super().url }
          it { is_expected.to eq "http://www.youtube.com/watch?v=SUkXvWn1m7Q" }
        end

        describe "#embed_url" do
          subject { super().embed_url }
          it { is_expected.to eq "//www.youtube.com/embed/SUkXvWn1m7Q" }
        end

        describe "#embed_code" do
          subject { super().embed_code }
          embed_code = '<iframe src="//www.youtube.com/embed/SUkXvWn1m7Q" ' \
                       'frameborder="0" allowfullscreen="allowfullscreen">' \
                       "</iframe>"
          it { is_expected.to eq embed_code }
        end

        describe "#title" do
          subject { super().title }
          it { is_expected.to eq nil }
        end

        describe "#description" do
          subject { super().description }
          it { is_expected.to eq nil }
        end

        describe "#keywords" do
          subject { super().keywords }
          it { is_expected.to be_nil }
        end

        describe "#duration" do
          subject { super().duration }
          it { is_expected.to eq 0 }
        end

        describe "#date" do
          subject { super().date }
          it { is_expected.to eq nil }
        end

        describe "#thumbnail_small" do
          subject { super().thumbnail_small }
          thumbnail_url = "https://i.ytimg.com/vi/SUkXvWn1m7Q/default.jpg"
          it { is_expected.to eq thumbnail_url }
        end

        describe "#thumbnail_medium" do
          subject { super().thumbnail_medium }
          thumbnail_url = "https://i.ytimg.com/vi/SUkXvWn1m7Q/mqdefault.jpg"
          it { is_expected.to eq thumbnail_url }
        end

        describe "#thumbnail_large" do
          subject { super().thumbnail_large }
          thumbnail_url = "https://i.ytimg.com/vi/SUkXvWn1m7Q/hqdefault.jpg"
          it { is_expected.to eq thumbnail_url }
        end

        describe "#thumbnail_large_2x" do
          subject { super().thumbnail_large_2x }
          thumbnail_url = "https://i.ytimg.com/vi/SUkXvWn1m7Q/sddefault.jpg"
          it { is_expected.to eq thumbnail_url }
        end

        describe "#thumbnail_maxres" do
          subject { super().thumbnail_maxres }
          thumbnail_url = "https://i.ytimg.com/vi/SUkXvWn1m7Q/maxresdefault.jpg"
          it { is_expected.to eq thumbnail_url }
        end

        describe "#thumbnail" do
          subject { super().thumbnail }
          thumbnail_url = "https://i.ytimg.com/vi/SUkXvWn1m7Q/hqdefault.jpg"
          it { is_expected.to eq thumbnail_url }
        end

        describe "#view_count" do
          subject { super().view_count }
          it { is_expected.to be == 0 }
        end
      end

      context "with video removed because of copyright claim" do
        subject { VideoInfo.new("http://www.youtube.com/watch?v=ffClNhwx0KU") }

        describe "#available?" do
          subject { super().available? }
          it { is_expected.to be_falsey }
        end
      end
    end

    context "with video mZqGqE0D0n4" do
      subject { VideoInfo.new("http://www.youtube.com/watch?v=mZqGqE0D0n4") }

      describe "#provider" do
        subject { super().provider }
        it { is_expected.to eq "YouTube" }
      end

      describe "#video_id" do
        subject { super().video_id }
        it { is_expected.to eq "mZqGqE0D0n4" }
      end

      describe "#url" do
        subject { super().url }
        it { is_expected.to eq "http://www.youtube.com/watch?v=mZqGqE0D0n4" }
      end

      describe "#embed_url" do
        subject { super().embed_url }
        it { is_expected.to eq "//www.youtube.com/embed/mZqGqE0D0n4" }
      end

      describe "#embed_code" do
        subject { super().embed_code }
        embed_code = '<iframe src="//www.youtube.com/embed/mZqGqE0D0n4" ' \
                     'frameborder="0" allowfullscreen="allowfullscreen">' \
                     "</iframe>"
        it { is_expected.to eq embed_code }
      end

      describe "#author" do
        subject { super().author }
        it { is_expected.to eql "Cherry Bloom" }
      end

      describe "#author_thumbnail" do
        subject { super().author_thumbnail }
        author_thumbnail = "https://yt3.googleusercontent.com/ytc/" \
                           "AL5GRJXbalTdHiTioC9wlrBz3GukwrYp1Q6EXcBYbugs" \
                           "=s88-c-k-c0x00ffffff-no-rj"

        xit { is_expected.to eql author_thumbnail }
      end

      describe "#author_url" do
        author_url = "https://www.youtube.com/channel/UCzxQk-rZGowoqMBKxGD5jSA"

        it { expect(subject.author_url).to eql(author_url) }

        it "can be called twice and receive the same value" do
          expect(subject.author_url).to eq(subject.author_url)
        end
      end

      describe "#title" do
        subject { super().title }
        it { is_expected.to eq "Cherry Bloom - King Of The Knife" }
      end

      describe "#description" do
        subject { super().description }
        description = "The first video from the upcoming album Secret Sounds," \
                      " to download in-stores April 14. " \
                      "Checkout http://www.cherrybloom.net"
        it { is_expected.to eq description }
      end

      describe "#keywords" do
        subject { super().keywords }
        keywords_list = %w[cherry bloom king of the knife guitar
          drum clip rock alternative tremplin Paris-Forum]
        it { is_expected.to eq keywords_list }
      end

      describe "#duration" do
        subject { super().duration }
        it { is_expected.to eq 176 }
      end

      describe "#width" do
        subject { super().width }
        it { is_expected.to be_nil }
      end

      describe "#height" do
        subject { super().height }
        it { is_expected.to be_nil }
      end

      describe "#date" do
        subject { super().date }

        it "should return date video was posted" do
          if api_key.nil?
            is_expected.to eq Time.parse("Sat Apr 12 2008", Time.now.utc)
          else
            is_expected.to eq Time.parse("Sat Apr 12 22:34:48 UTC 2008",
              Time.now.utc)
          end
        end
      end

      describe "#thumbnail_small" do
        subject { super().thumbnail_small }
        thumbnail_url = "https://i.ytimg.com/vi/mZqGqE0D0n4/default.jpg"
        it { is_expected.to eq thumbnail_url }
      end

      describe "#thumbnail_medium" do
        subject { super().thumbnail_medium }
        thumbnail_url = "https://i.ytimg.com/vi/mZqGqE0D0n4/mqdefault.jpg"
        it { is_expected.to eq thumbnail_url }
      end

      describe "#thumbnail_large" do
        subject { super().thumbnail_large }
        thumbnail_url = "https://i.ytimg.com/vi/mZqGqE0D0n4/hqdefault.jpg"
        it { is_expected.to eq thumbnail_url }
      end

      describe "#thumbnail_large_2x" do
        subject { super().thumbnail_large_2x }
        thumbnail_url = "https://i.ytimg.com/vi/mZqGqE0D0n4/sddefault.jpg"
        it { is_expected.to eq thumbnail_url }
      end

      describe "#thumbnail_maxres" do
        subject { super().thumbnail_maxres }
        thumbnail_url = "https://i.ytimg.com/vi/mZqGqE0D0n4/maxresdefault.jpg"
        it { is_expected.to eq thumbnail_url }
      end

      describe "#view_count" do
        subject { super().view_count }
        it { is_expected.to be > 4000 }
      end
    end

    context "with video oQ49W_xKzKA" do
      subject { VideoInfo.new("http://www.youtube.com/watch?v=oQ49W_xKzKA") }

      it "should properly apply arbitrary url attributes" do
        embed_code = subject.embed_code(url_attributes: {autoplay: 1})
        expect(embed_code).to match(/autoplay=1/)
      end
    end

    context "with video oQ49W_xKzKA" do
      subject { VideoInfo.new("http://www.youtube.com/watch?v=oQ49W_xKzKA") }

      describe "#provider" do
        subject { super().provider }
        it { is_expected.to eq "YouTube" }
      end

      describe "#video_id" do
        subject { super().video_id }
        it { is_expected.to eq "oQ49W_xKzKA" }
      end
    end

    context "with video Xp6CXF-Cesg" do
      subject { VideoInfo.new("http://www.youtube.com/watch?v=Xp6CXF-Cesg") }

      describe "#provider" do
        subject { super().provider }
        it { is_expected.to eq "YouTube" }
      end

      describe "#video_id" do
        subject { super().video_id }
        it { is_expected.to eq "Xp6CXF-Cesg" }
      end
    end

    context "with video VeasFckfMHY in user url" do
      video_url = "http://www.youtube.com/user/EducatorVids3?v=VeasFckfMHY"
      subject { VideoInfo.new(video_url) }

      describe "#provider" do
        subject { super().provider }
        it { is_expected.to eq "YouTube" }
      end

      describe "#video_id" do
        subject { super().video_id }
        it { is_expected.to eq "VeasFckfMHY" }
      end

      describe "#url" do
        subject { super().url }
        it { is_expected.to eq video_url }
      end
    end

    context "with video VeasFckfMHY after params" do
      video_url = "http://www.youtube.com/watch?feature=player_profilepage&v=VeasFckfMHY"
      subject { VideoInfo.new(video_url) }

      describe "#provider" do
        subject { super().provider }
        it { is_expected.to eq "YouTube" }
      end

      describe "#video_id" do
        subject { super().video_id }
        it { is_expected.to eq "VeasFckfMHY" }
      end

      describe "#url" do
        subject { super().url }
        it { is_expected.to eq video_url }
      end
    end

    context "with video VeasFckfMHY in path" do
      subject { VideoInfo.new("http://www.youtube.com/v/VeasFckfMHY") }

      describe "#provider" do
        subject { super().provider }
        it { is_expected.to eq "YouTube" }
      end

      describe "#video_id" do
        subject { super().video_id }
        it { is_expected.to eq "VeasFckfMHY" }
      end
    end

    context "with video VeasFckfMHY in e path" do
      subject { VideoInfo.new("http://www.youtube.com/e/VeasFckfMHY") }

      describe "#provider" do
        subject { super().provider }
        it { is_expected.to eq "YouTube" }
      end

      describe "#video_id" do
        subject { super().video_id }
        it { is_expected.to eq "VeasFckfMHY" }
      end
    end

    context "with video VeasFckfMHY in embed path" do
      subject { VideoInfo.new("http://www.youtube.com/embed/VeasFckfMHY") }

      describe "#provider" do
        subject { super().provider }
        it { is_expected.to eq "YouTube" }
      end

      describe "#video_id" do
        subject { super().video_id }
        it { is_expected.to eq "VeasFckfMHY" }
      end
    end

    context "with video JM9NgvjjVng in youtu.be url" do
      subject { VideoInfo.new("http://youtu.be/JM9NgvjjVng") }

      describe "#provider" do
        subject { super().provider }
        it { is_expected.to eq "YouTube" }
      end

      describe "#video_id" do
        subject { super().video_id }
        it { is_expected.to eq "JM9NgvjjVng" }
      end
    end

    context "without http or www" do
      subject { VideoInfo.new("youtu.be/JM9NgvjjVng") }

      describe "#provider" do
        subject { super().provider }
        it { is_expected.to eq("YouTube") }
      end

      describe "#video_id" do
        subject { super().video_id }
        it { is_expected.to eq "JM9NgvjjVng" }
      end
    end

    context "with video url in text" do
      url_in_text = '<a href="http://www.youtube.com/watch?v=mZqGqE0D0n4">' \
                    "http://www.youtube.com/watch?v=mZqGqE0D0n4</a>"
      subject { VideoInfo.new(url_in_text) }

      describe "#provider" do
        subject { super().provider }
        it { is_expected.to eq("YouTube") }
      end

      describe "#video_id" do
        subject { super().video_id }
        it { is_expected.to eq("mZqGqE0D0n4") }
      end
    end

    context "with iframe attributes" do
      subject { VideoInfo.new("http://www.youtube.com/watch?v=mZqGqE0D0n4") }

      describe "#provider" do
        subject { super().provider }
        it { is_expected.to eq("YouTube") }
      end

      it "should properly apply dimensions attributes" do
        dimensions = {width: 800, height: 600}
        embed_code = subject.embed_code(iframe_attributes: dimensions)
        expect(embed_code).to match(/width="800"/)
        expect(embed_code).to match(/height="600"/)
      end
    end

    context "with arbitrary iframe_attributes" do
      subject { VideoInfo.new("http://www.youtube.com/watch?v=mZqGqE0D0n4") }

      describe "#provider" do
        subject { super().provider }
        it { is_expected.to eq("YouTube") }
      end

      it "should properly apply arbitrary attributes" do
        attributes = {"data-colorbox": true}
        embed_code = subject.embed_code(iframe_attributes: attributes)
        expect(embed_code).to match(/data-colorbox="true"/)
      end
    end

    context "with full screen video URLs" do
      subject { VideoInfo.new("http://www.youtube.com/v/mZqGqE0D0n4") }

      describe "#provider" do
        subject { super().provider }
        it { is_expected.to eq "YouTube" }
      end

      describe "#video_id" do
        subject { super().video_id }
        it { is_expected.to eq "mZqGqE0D0n4" }
      end

      describe "#url" do
        subject { super().url }
        it { is_expected.to eq "http://www.youtube.com/v/mZqGqE0D0n4" }
      end

      describe "#embed_url" do
        subject { super().embed_url }
        it { is_expected.to eq "//www.youtube.com/embed/mZqGqE0D0n4" }
      end

      describe "#embed_code" do
        subject { super().embed_code }
        embed_code = '<iframe src="//www.youtube.com/embed/mZqGqE0D0n4" ' \
                     'frameborder="0" allowfullscreen="allowfullscreen">' \
                     "</iframe>"
        it { is_expected.to eq embed_code }
      end

      describe "#title" do
        subject { super().title }
        it { is_expected.to eq "Cherry Bloom - King Of The Knife" }
      end

      describe "#description" do
        subject { super().description }
        description = "The first video from the upcoming album Secret Sounds," \
                      " to download in-stores April 14. " \
                      "Checkout http://www.cherrybloom.net"
        it { is_expected.to eq description }
      end

      describe "#keywords" do
        subject { super().keywords }
        keywords_list = %w[cherry bloom king of the knife guitar
          drum clip rock alternative tremplin Paris-Forum]
        it { is_expected.to eq keywords_list }
      end

      describe "#duration" do
        subject { super().duration }
        it { is_expected.to eq 176 }
      end

      describe "#width" do
        subject { super().width }
        it { is_expected.to be_nil }
      end

      describe "#height" do
        subject { super().height }
        it { is_expected.to be_nil }
      end

      describe "#date" do
        subject { super().date }

        it "should return date video was posted" do
          if api_key.nil?
            is_expected.to eq Time.parse("Sat Apr 12 2008", Time.now.utc)
          else
            is_expected.to eq Time.parse("Sat Apr 12 22:34:48 UTC 2008",
              Time.now.utc)
          end
        end
      end

      describe "#thumbnail_small" do
        subject { super().thumbnail_small }
        thumbnail_url = "https://i.ytimg.com/vi/mZqGqE0D0n4/default.jpg"
        it { is_expected.to eq thumbnail_url }
      end

      describe "#thumbnail_medium" do
        subject { super().thumbnail_medium }
        thumbnail_url = "https://i.ytimg.com/vi/mZqGqE0D0n4/mqdefault.jpg"
        it { is_expected.to eq thumbnail_url }
      end

      describe "#thumbnail_large" do
        subject { super().thumbnail_large }
        thumbnail_url = "https://i.ytimg.com/vi/mZqGqE0D0n4/hqdefault.jpg"
        it { is_expected.to eq thumbnail_url }
      end

      describe "#thumbnail_large_2x" do
        subject { super().thumbnail_large_2x }
        thumbnail_url = "https://i.ytimg.com/vi/mZqGqE0D0n4/sddefault.jpg"
        it { is_expected.to eq thumbnail_url }
      end

      describe "#view_count" do
        subject { super().view_count }
        it { is_expected.to be > 80 }
      end
    end
  end
end
