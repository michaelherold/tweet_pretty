require 'spec_helper'

describe TweetPretty::EntityFormatter do
  let(:no_entities_tweet_data) { { :id => 1, :text => "This is a test tweet" } }
  let(:full_tweet_data) {
    {
        :id => 1,
        :text => "Test tweet. #test @test https://t.co/t This is a test.",
        :entities => {
            :hashtags => [
                {
                    :text => "test",
                    :indices => [12, 17]
                }
            ],
            :urls => [
                {
                    :url          => "https://t.co/t",
                    :display_url  => "example.com",
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
        expected = "Test tweet. <a class='hashtag' href='http://twitter.com/search?q=%23test' target='_blank'>#test</a> <a class='user-mention' title='Test User' href='http://twitter.com/test' target='_blank'>@test</a> <a class='link' href='https://t.co/t' target='_blank'>example.com</a> This is a test."
        subject.should == expected
      end
    end
  end
end