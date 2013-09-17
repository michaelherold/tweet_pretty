module TweetPretty
  class EntityFormatter
    def initialize(tweet)
      @replacements = {}
      @tweet = tweet
    end

    def prettify
      return html_escape(@tweet.text) unless @tweet.entities?

      ["hashtags", "urls", "user_mentions"].each do |type|
        add_replacements type
      end

      result = ""
      last_i = 0
      i = 0

      while i < @tweet.text.length do
        replacing_at = @replacements[i]

        if replacing_at
          stop = replacing_at[0]
          f = replacing_at[1]
          entity = replacing_at[2]
          if i > last_i
            result += html_escape(@tweet.text[last_i...i])
          end
          result += send(f, @tweet.text[i...stop], entity)
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

    def self.format(tweet)
      self.new(tweet).prettify
    end

    private

    def add_replacements(type)
      return unless ["hashtags", "urls", "user_mentions"].include? type
      @tweet.send(type).each do |entity|
        @replacements[entity.indices[0]] = [entity.indices[1], "replace_#{type}", entity]
      end
    end

    def html_escape(s)
      ::ERB::Util.html_escape(s)
    end

    def replace_hashtags(text, entity)
      css_class = TweetPretty.config.hashtag_class
      "<a class='#{css_class}' href='http://twitter.com/search?q=##{url_encode entity.text}'>#{html_escape text}</a>"
    end

    def replace_user_mentions(text, entity)
      css_class = TweetPretty.config.user_mention_class
      "<a class='#{css_class}' title='#{html_escape entity.name}' href='http://twitter.com/#{url_encode entity.screen_name}'>#{html_escape text}</a>"
    end

    def replace_urls(text, entity)
      css_class = TweetPretty.config.url_class
      "<a class='#{css_class}' href='#{entity.url}'>#{html_escape entity.display_url}</a>"
    end

    def url_encode(s)
      ::ERB::Util.url_encode(s)
    end
  end
end