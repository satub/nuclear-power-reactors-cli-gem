# nuclear-power-reactors-cli-gem
CLI GEM for listing nuclear reactor data from information provided on IAEA.org public resources

## Installation

Add this line to your application's Gemfile:

```ruby
gem "nuclear-power-reactors-cli-gem", :git => "git://github.com/satub/nuclear-power-reactors-cli-gem"
```

And then execute:

    $ bundle

## Usage

After installation, type this on your command line to run the program:

    $ nuclear-power-reactors

The program will print a welcome message and list all the countries where nuclear power reactor data is available at https://www.iaea.org/PRIS/ . Follow the prompts to display data in the country of your choice or to display reactor details.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/satub/nuclear-power-reactors-cli-gem.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
