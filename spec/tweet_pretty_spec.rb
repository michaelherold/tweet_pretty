require 'spec_helper'

describe TweetPretty do
  let (:tweet) { Twitter::Tweet.new({ id: 1, text: "This is a test tweet" }) }

  describe "#to_html" do
    it "is monkey patched into Twitter::Tweet" do
      expect {
        tweet.to_html
      }.not_to raise_error
    end
  end
end