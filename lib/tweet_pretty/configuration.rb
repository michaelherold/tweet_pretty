require 'singleton'
require 'tweet_pretty/configuration_hash'

module TweetPretty
  def self.configure(options = nil)
    Configuration.instance.configure(options)
  end

  def self.config
    Configuration.instance.data
  end

  class Configuration
    include Singleton

    attr_accessor :data

    OPTIONS = [
        :hashtag_class,
        :url_class,
        :user_mention_class
    ]

    def initialize
      @data = TweetPretty::ConfigurationHash.new
      set_defaults
    end

    def configure(options)
      @data.rmerge!(options)
    end

    def set_defaults
      @data[:hashtag_class] = "hashtag"
      @data[:url_class] = "link"
      @data[:user_mention_class] = "user-mention"
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