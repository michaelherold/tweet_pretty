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
        :media_html_string,
        :hashtags_html_string,
        :urls_html_string,
        :user_mentions_html_string,
        :media_md_string,
        :hashtags_md_string,
        :urls_md_string,
        :user_mentions_md_string,
        :media_rst_string,
        :hashtags_rst_string,
        :urls_rst_string,
        :user_mentions_rst_string,
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
      @data[:media_html_string] = @data[:urls_html_string] = %q(<a class="%{css}" href="%{url}"%{target}>%{display_url}</a>)
      @data[:hashtags_html_string] = %q(<a class="%{css}" href="http://twitter.com/search?q=%%23%{entity_text}"%{target}>%{text}</a>)
      @data[:user_mentions_html_string] = %q(<a class="%{css}" title="%{name}" href="http://twitter.com/%{screen_name}"%{target}>%{text}</a>)
      @data[:media_md_string] = @data[:urls_md_string] = %q|[%{display_url}](%{url})|
      @data[:hashtags_md_string] = %q|[%{text}](http://twitter.com/search?q=%%23%{entity_text})|
      @data[:user_mentions_md_string] = %q|[%{text}](http://twitter.com/%{screen_name})|
      @data[:media_rst_string] = @data[:urls_rst_string] = %q(`%{display_url} <%{url}>`)
      @data[:hashtags_rst_string] = %q(`%{text} <http://twitter.com/search?q=%%23%{entity_text}>`)
      @data[:user_mentions_rst_string] = %q(`%{text} <http://twitter.com/%{screen_name}>`)
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