require 'erb'

require 'twitter'

require 'gem_ext'
require 'tweet_pretty/configuration'
require 'tweet_pretty/entity_formatter'
require 'tweet_pretty/replacement'
require 'tweet_pretty/version' unless defined? TweetPretty::VERSION

module TweetPretty

  ##
  # @return String
  def self.to_html(tweet, opts={})
    EntityFormatter.format(tweet, opts)
  end
end
