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

    def initialize(entity)
      unless [Twitter::Entity, Twitter::Media::Photo].any? {|type| entity.is_a? type }
        raise ArgumentError, "Argument is of wrong type (#{entity.class} for Twitter::Entity, Twitter::Media::Photo)"
      end

      @entity = entity
      @start, @finish = @entity.indices
    end

    def type
      @type ||= TYPES[@entity.class]
    end

    def <=>(other)
      raise ArgumentError, "Expected a #{self.class} and received a #{other.class}" unless other.is_a? TweetPretty::Replacement
      start <=> other.start
    end
  end
end