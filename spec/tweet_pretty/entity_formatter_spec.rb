# encoding: utf-8

require 'spec_helper'

describe TweetPretty::EntityFormatter do
  let(:no_entities_tweet_data) { { :id => 1, :text => "This is a test tweet" } }
  let(:full_tweet_data) {
    {
        :id => 1,
        :text => "Test tweet. #test @test https://t.co/t http://t.co/m This is a test.",
        :entities => {
            :hashtags => [
                {
                    :text => "test",
                    :indices => [12, 17]
                }
            ],
            :media => [
                {
                    :id => 1,
                    :type => "photo",
                    :url => "http://t.co/m",
                    :display_url => "pic.twitter.com/m",
                    :indices => [39, 52]
                }
            ],
            :urls => [
                {
                    :url          => "https://t.co/t",
                    :expanded_url => "example.com/this-is-a-long-url",
                    :display_url  => "example.com/this-is-a-lon…",
                    :indices      => [24, 38]
                }
            ],
            :user_mentions => [
                {
                    :screen_name  => "test",
                    :name         => "Test User",
                    :indices      => [18, 23]
                }
            ]
        }
    }
  }
  before(:each) { TweetPretty::Configuration.set_defaults }

  context "on a tweet with no entities" do
    let(:tweet) { Twitter::Tweet.new(no_entities_tweet_data) }
    subject { TweetPretty::EntityFormatter.format(tweet) }

    describe "#format" do
      it "returns the tweet text" do
        subject.should == tweet.text
      end
    end
  end

  context "on a tweet with all entity types" do
    let(:tweet) { Twitter::Tweet.new(full_tweet_data) }
    subject { TweetPretty::EntityFormatter.format(tweet) }

    describe "#format" do
      it "returns the expected output" do
        expected = %q(Test tweet. <a class="hashtag" href="http://twitter.com/search?q=%23test">#test</a> <a class="user-mention" title="Test User" href="http://twitter.com/test">@test</a> <a class="link" href="https://t.co/t">example.com/this-is-a-lon…</a> <a class="media" href="http://t.co/m">pic.twitter.com/m</a> This is a test.)
        subject.should == expected
      end

      it "returns the expected Markdown output" do
        expected = %q|Test tweet. [#test](http://twitter.com/search?q=%23test) [@test](http://twitter.com/test) [example.com/this-is-a-lon…](https://t.co/t) [pic.twitter.com/m](http://t.co/m) This is a test.|
        expect(TweetPretty::EntityFormatter.format(tweet, :md)).to eq(expected)
      end

      describe "allows a target" do
        after { TweetPretty.config.target = nil
        }
        it "to be a blank window" do
          TweetPretty.config.target = :blank
          expected = %q(Test tweet. <a class="hashtag" href="http://twitter.com/search?q=%23test" target="_blank">#test</a> <a class="user-mention" title="Test User" href="http://twitter.com/test" target="_blank">@test</a> <a class="link" href="https://t.co/t" target="_blank">example.com/this-is-a-lon…</a> <a class="media" href="http://t.co/m" target="_blank">pic.twitter.com/m</a> This is a test.)
          expect(TweetPretty::EntityFormatter.format(tweet)).to eq(expected)
        end

        it "to be anything else" do
          TweetPretty.config.target = "foo"
          expected = %q(Test tweet. <a class="hashtag" href="http://twitter.com/search?q=%23test" target="foo">#test</a> <a class="user-mention" title="Test User" href="http://twitter.com/test" target="foo">@test</a> <a class="link" href="https://t.co/t" target="foo">example.com/this-is-a-lon…</a> <a class="media" href="http://t.co/m" target="foo">pic.twitter.com/m</a> This is a test.)
          expect(TweetPretty::EntityFormatter.format(tweet)).to eq(expected)
        end
      end
    end
  end
end