# ActiveRecordMultiConfig

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'active_record_multi_config'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_record_multi_config

## Usage

This gem will allow multiple db config files to be used in a Rails 3 project. All you have to do is
```ruby
  class MyTable < ActiveRecord::Base
    self.config_file = 'my_config'
  end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
