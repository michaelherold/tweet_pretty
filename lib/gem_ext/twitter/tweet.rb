require 'tweet_pretty'

module Twitter
  class Tweet
    def to_html
      TweetPretty.to_html(self)
    end
  end
end