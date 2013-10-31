module TweetPretty
  class EntityFormatter
    def initialize(tweet, opts = {})
      @tweet = tweet
      @target = opts[:target] || :blank
    end

    def prettify
      return html_escape(@tweet.text) unless @tweet.entities?

      result = ""
      last_i = 0
      i = 0

      while i < @tweet.text.length do
        replacing_at = replacements[i]

        if replacing_at
          stop = replacing_at[0]
          entity = replacing_at[1]
          if i > last_i
            result += html_escape(@tweet.text[last_i...i])
          end
          result += replace(@tweet.text[i...stop], entity, replacing_at[2])
          i = stop - 1
          last_i = stop
        end

        i += 1
      end

      if i > last_i
        result += html_escape(@tweet.text[last_i...i])
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
      replacements = {}

      entity_types.each do |type|
        @tweet.send(type).each do |entity|
          replacements[entity.indices[0]] = [entity.indices[1], entity, type]
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