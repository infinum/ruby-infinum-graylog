# InfinumGraylog

Gem for sending sql and controller actions to graylog

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'infinum_graylog'
```

And then execute:

    $ bundle

## Usage

Create `config/initializers/infinum_graylog.rb`

```ruby
InfinumGraylog.configure do |config|
  # config.skip_environments = ['development', 'test']
  # config.skip_statuses = [404, 500]
  # config.skippable_sql_actions = ['PhrasingPhrase Load', 'PhrasingImage Load']
end

InfinumGraylog::Subscriber.subscribe

```

If you want additional information for action processing you can add this to your controllers:

```ruby
  def append_info_to_payload(payload)
    super
    payload[:user] = current_user.email if current_user.present?
    payload[:response] = response.body if request.format == :json
  end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/infinum/ruby-infinum-graylog. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the InfinumGraylog project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/infinum/ruby-infinum-graylog/blob/master/CODE_OF_CONDUCT.md).
