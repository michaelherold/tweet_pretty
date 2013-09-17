# TweetPretty

[![Build Status](https://travis-ci.org/michaelherold/tweet_pretty.png?branch=master)][travis]
[![Dependency Status](https://gemnasium.com/michaelherold/tweet_pretty.png?travis)][gemnasium]
[![Code Climate](https://codeclimate.com/github/michaelherold/tweet_pretty.png)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/michaelherold/tweet_pretty/badge.png?branch=master)][coveralls]

[gem]: https://rubygems.org/gems/twitter
[travis]: http://travis-ci.org/michaelherold/twe
[gemnasium]: https://gemnasium.com/michaelherold/tweet_pretty
[codeclimate]: https://codeclimate.com/github/michaelherold/tweet_pretty
[coveralls]: https://coveralls.io/r/michaelherold/tweet_pretty
[pledgie]: http://pledgie.com/campaigns/18388

As the missing formatting tool for the Twitter gem, TweetPretty allows you to
easily replace entities in tweets to conform to [Twitter's Display Requirements][display-reqs].

[display-reqs]: https://dev.twitter.com/terms/display-requirements

## Installation

Add this line to your application's Gemfile:

    gem 'tweet_pretty'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tweet_pretty

## Usage

Use the [Twitter gem][twitter-gem] to pull a tweet:

```ruby
    tweet = Twitter.status(379713438806597632)
```

Then use the ```to_html``` method to convert its ```text``` attribute into
a properly converted HTML snippet:

```ruby
    tweet.text
    => "Pardon this test tweet. It's hard to find tweets containing at least one of each entity. #devtest @mherold https://t.co/CbYo8pjDDO"
    tweet.to_html
    => "Pardon this test tweet. It&#39;s hard to find tweets containing at least one of each entity. <a class='hashtag' href='http://twitter.com/search?q=#devtest'>#devtest</a> <a class='user-mention' title='Michael Herold' href='http://twitter.com/mherold'>@mherold</a> <a class='link' href='https://t.co/CbYo8pjDDO'>twitter.com/mherold</a>"
```

[twitter-gem]: https://github.com/sferik/twitter

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
