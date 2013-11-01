require 'tweet_pretty/replacement'

module TweetPretty
  class EntityFormatter
    def prettify(tweet)
      return html_escape(tweet.text) unless tweet.entities?

      result = tweet.text.dup
      replacements = create_replacements(tweet)

      replacements.reverse_each do |r|
        result[r.start...r.finish] = r.replace(result[r.start...r.finish])
      end

      result
    end

    def self.format(tweet)
      self.new.prettify(tweet)
    end

    private

    def create_replacements(tweet)
      replacements = []

      entity_types.each do |type|
        tweet.send(type).each do |entity|
          replacements << Replacement.new(entity)
        end
      end

      replacements.sort
    end

    def entity_types
      ["hashtags", "media", "urls", "user_mentions"]
    end

    def html_escape(s)
      ::ERB::Util.html_escape(s)
    end

  end
end