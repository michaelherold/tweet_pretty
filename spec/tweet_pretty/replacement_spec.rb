require 'spec_helper'

describe TweetPretty::Replacement do
  let(:entities) {
    {
        :hashtags => [
            {
                :text => "test",
                :indices => [12, 17]
            }
        ],
        :user_mentions => [
            {
                :screen_name  => "test",
                :name         => "Test User",
                :indices      => [18, 23]
            }
        ]
    }
  }

  subject { TweetPretty::Replacement.new(Twitter::Entity::Hashtag.new(entities[:hashtags][0])) }

  context "is Comparable" do
    let(:r2) { TweetPretty::Replacement.new(Twitter::Entity::UserMention.new(entities[:user_mentions][0])) }

    it { expect(subject < r2).to be_true }
    it { expect(subject > r2).to be_false }
    it { expect(subject == r2).to be_false }
  end

  describe "#type" do
    it { expect(subject.type).to eq("hashtags") }
  end

  describe ".new" do
    it "raises an error if passed the wrong type" do
      expect{TweetPretty::Replacement.new("test")}.to raise_error ArgumentError
    end
  end
end