require 'tweet_pretty/replacement'

module TweetPretty
  class EntityFormatter
    def initialize(tweet, opts = {})
      @tweet = tweet
      @target = opts[:target] || :blank
    end

    def prettify
      return html_escape(@tweet.text) unless @tweet.entities?

      result = @tweet.text.dup

      replacements.sort.reverse_each do |r|
        result[r.start...r.finish] = replace(result[r.start...r.finish], r.entity, r.type)
      end

      result
    end

    def replacements
      @replacements ||= create_replacements
    end

    def self.format(tweet)
      self.new(tweet).prettify
    end

    private

    def create_replacements
      replacements = []

      entity_types.each do |type|
        @tweet.send(type).each do |entity|
          replacements << Replacement.new(entity)
        end
      end

      replacements
    end

    def entity_types
      ["hashtags", "media", "urls", "user_mentions"]
    end

    def html_escape(s)
      ::ERB::Util.html_escape(s)
    end

    def replace(text, entity, type)
      return text unless entity_types.include? type

      TweetPretty.config.send("#{type}_string") % Hash.new.tap do |h|
        h[:css] = TweetPretty.config.send("#{type}_class")
        h[:text] = html_escape(text)
        h[:display_url] = html_escape(entity.display_url) if entity.respond_to? "display_url"
        h[:entity_text] = url_encode(entity.text) if entity.respond_to? "text"
        h[:name] = html_escape(entity.name) if entity.respond_to? "name"
        h[:screen_name] = html_escape(entity.screen_name) if entity.respond_to? "screen_name"
        h[:url] = entity.url if entity.respond_to? "url"
      end
    end

    def url_encode(s)
      ::ERB::Util.url_encode(s)
    end
  end
end