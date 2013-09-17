require 'spec_helper'

describe TweetPretty::Configuration do

  describe "attribute setter generator" do
    subject { TweetPretty::Configuration.instance }

    it "generators setters" do
      subject.hashtag_class = "test"
      subject.hashtag_class.should == "test"
    end
  end

  describe "#configure" do
    it "sets individual values" do
      TweetPretty.configure(:hashtag_class => "test")
      TweetPretty.config.hashtag_class.should == "test"
    end

    it "sets via a hash" do
      config = {:hashtag_class => "test1", :url_class => "test2"}
      TweetPretty.configure(config)
      TweetPretty.config.hashtag_class.should == "test1"
      TweetPretty.config.url_class.should == "test2"
    end
  end

  describe "#new" do
    it "raises an exception" do
      expect {
        TweetPretty::Configuration.new
      }.to raise_error NoMethodError
    end
  end

  describe "#set_defaults" do
    it "sets the default value for each option" do
      TweetPretty::Configuration.set_defaults
      TweetPretty.config.hashtag_class.should == "hashtag"
    end
  end

  describe ".set_defaults" do
    subject { TweetPretty::Configuration.instance }

    it "sets the default value for each option" do
      subject.set_defaults
      subject.hashtag_class.should == "hashtag"
    end
  end
end