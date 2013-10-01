# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tweet_pretty/version'

Gem::Specification.new do |spec|
  spec.name          = 'tweet_pretty'
  spec.version       = TweetPretty::VERSION
  spec.authors       = ["Michael Herold"]
  spec.email         = ["michael.j.herold@gmail.com"]
  spec.description   = %q{Replace hashtags, links, and user mentions in Twitter::Tweets}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/michaelherold/tweet_pretty/"
  spec.license       = "MIT"

  spec.files         = %w{LICENSE.md README.md Rakefile tweet_pretty.gemspec}
  spec.files         += Dir.glob("lib/**/*.rb")
  spec.files         += Dir.glob("spec/**/*")
  spec.test_files    = Dir.glob("spec/**/*")
  spec.require_paths = ["lib"]

  #spec.add_dependency "twitter", ">= 4.8.1"

  spec.add_development_dependency "bundler", "~> 1.3"
end
