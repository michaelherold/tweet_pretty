module TweetPretty
  class Replacement

    include Comparable

    TYPES = {
        Twitter::Entity::Hashtag => "hashtags",
        Twitter::Media::Photo => "media",
        Twitter::Entity::URI => "urls",
        Twitter::Entity::UserMention => "user_mentions",
    }

    attr_reader :entity, :start, :finish

    def initialize(entity, format=:html)
      unless [Twitter::Entity, Twitter::Media::Photo].any? {|type| entity.is_a? type }
        raise ArgumentError, "Argument is of wrong type (#{entity.class} for Twitter::Entity, Twitter::Media::Photo)"
      end

      @entity = entity
      @start, @finish = @entity.indices
      @format = format
    end

    def css_class
      TweetPretty.config.send("#{type}_class")
    end

    def format
      @format
    end

    def replace(text)
      string % Hash.new.tap do |h|
        h[:css] = css_class
        h[:text] = html_escape(text)
        h[:display_url] = html_escape(entity.display_url) if entity.respond_to? "display_url"
        h[:entity_text] = url_encode(entity.text) if entity.respond_to? "text"
        h[:name] = html_escape(entity.name) if entity.respond_to? "name"
        h[:screen_name] = html_escape(entity.screen_name) if entity.respond_to? "screen_name"
        h[:url] = entity.url if entity.respond_to? "url"
        h[:target] = target
      end
    end

    def string
      TweetPretty.config.send("#{type}_#{format}_string")
    end

    def target
      if TweetPretty.config.target.nil?
        ""
      elsif TweetPretty.config.target == :blank
        %q( target="_blank")
      else
        %Q( target="#{TweetPretty.config.target}")
      end
    end

    def type
      @type ||= TYPES[@entity.class]
    end

    def <=>(other)
      raise ArgumentError, "Expected a #{self.class} and received a #{other.class}" unless other.is_a? TweetPretty::Replacement
      start <=> other.start
    end

    private

    def html_escape(s)
      ::ERB::Util.html_escape(s)
    end

    def url_encode(s)
      ::ERB::Util.url_encode(s)
    end
  end
end