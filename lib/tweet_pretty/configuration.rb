# encoding: utf-8

require 'singleton'
require 'tweet_pretty/configuration_hash'

module TweetPretty
  def self.configure(options = nil)
    Configuration.instance.configure(options)
  end

  def self.config
    Configuration.instance
  end

  class Configuration
    include Singleton

    attr_accessor :data

    OPTIONS = [
        :media_class,
        :hashtags_class,
        :urls_class,
        :user_mentions_class,
        :media_string,
        :hashtags_string,
        :urls_string,
        :user_mentions_string,
        :target,
    ]

    def initialize
      @data = TweetPretty::ConfigurationHash.new
      set_defaults
    end

    def configure(options)
      @data.rmerge!(options)
    end

    def set_defaults
      @data[:media_class] = "media"
      @data[:hashtags_class] = "hashtag"
      @data[:urls_class] = "link"
      @data[:user_mentions_class] = "user-mention"
      @data[:media_string] = @data[:urls_string] = %q(<a class="%{css}" href="%{url}"%{target}>%{display_url}</a>)
      @data[:hashtags_string] = %q(<a class="%{css}" href="http://twitter.com/search?q=%%23%{entity_text}"%{target}>%{text}</a>)
      @data[:user_mentions_string] = %q(<a class="%{css}" title="%{name}" href="http://twitter.com/%{screen_name}"%{target}>%{text}</a>)
      @data[:target] = nil
    end

    ##
    # Define instance methods for getter and setter of each option.
    #
    OPTIONS.each do |option|
      define_method option do
        @data[option]
      end
      define_method "#{option}=" do |value|
        @data[option] = value
      end
    end

    ##
    # Define class methods for getter and setter of each option.
    #
    instance_eval(OPTIONS.map do |op|
      option = op.to_s
      <<-EOS
      def #{option}
        instance.data[:#{option}]
      end

      def #{option}=(value)
        instance.data[:#{option}] = value
      end
      EOS
    end.join("\n\n"))

    def self.set_defaults
      instance.set_defaults
    end
  end
end