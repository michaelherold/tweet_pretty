require 'erb'

require 'twitter'

require 'gem_ext'
require 'tweet_pretty/configuration'
require 'tweet_pretty/entity_formatter'
require 'tweet_pretty/version' unless defined? TweetPretty::VERSION

module TweetPretty

  ##
  # @return String
  def self.to_html(tweet)
    EntityFormatter.format(tweet)
  end
end
