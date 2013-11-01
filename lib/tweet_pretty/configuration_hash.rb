require 'core_ext/hash'

module TweetPretty
  class ConfigurationHash < Hash
    include HashRecursiveMerge
  end
end