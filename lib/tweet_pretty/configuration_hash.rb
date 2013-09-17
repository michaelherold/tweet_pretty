require 'core_ext/hash'

module TweetPretty
  class ConfigurationHash < Hash
    include HashRecursiveMerge

    def method_missing(method, *args, &block)
      has_key?(method) ? self[method] : super
    end
  end
end