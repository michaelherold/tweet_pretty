require 'tweet_pretty'

module Twitter
  class Tweet
    def to_html
      TweetPretty.to_html(self)
    end

    def to_md
      TweetPretty.to_md(self)
    end
  end
end