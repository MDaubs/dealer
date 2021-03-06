# Dealer
[![Code Climate](https://codeclimate.com/github/MDaubs/dealer/badges/gpa.svg)](https://codeclimate.com/github/MDaubs/dealer)
[![Build Status](https://travis-ci.org/MDaubs/dealer.svg)](https://travis-ci.org/MDaubs/dealer)

Dealer is a framework for building card games. It includes a DSL and primitives
for building card games as well as a reference client/server implementation
using WebSockets.

**It's very much a work-in-progress.**

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dealer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dealer

## Usage

See the sample application [Go Fish](samples/go_fish.rb)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec dealer` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mdaubs/dealer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
