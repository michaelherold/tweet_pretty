require 'spec_helper'

describe TweetPretty::Configuration do

  describe "attribute setter generator" do
    subject { TweetPretty::Configuration.instance }

    it "generators setters" do
      subject.hashtags_class = "test"
      expect(TweetPretty.config.hashtags_class).to eq("test")
    end
  end

  describe "#configure" do
    it "sets individual values" do
      TweetPretty.configure(:hashtags_class => "test")
      expect(TweetPretty.config.hashtags_class).to eq("test")
    end

    it "sets via a hash" do
      config = {:hashtags_class => "test1", :urls_class => "test2"}
      TweetPretty.configure(config)
      expect(TweetPretty.config.hashtags_class).to eq("test1")
      expect(TweetPretty.config.urls_class).to eq("test2")
    end
  end

  describe "#new" do
    it "raises an exception" do
      expect { TweetPretty::Configuration.new }.to raise_error NoMethodError
    end
  end

  describe "#set_defaults" do
    it "sets the default value for each option" do
      TweetPretty::Configuration.set_defaults
      expect(TweetPretty.config.hashtags_class).to eq("hashtag")
    end
  end

  describe ".set_defaults" do
    subject { TweetPretty::Configuration.instance }

    it "sets the default value for each option" do
      subject.set_defaults
      expect(subject.hashtags_class).to eq("hashtag")
    end
  end
end