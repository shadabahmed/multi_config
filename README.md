# MultiConfig [![Build Status](https://secure.travis-ci.org/shadabahmed/multi_config.png)](https://secure.travis-ci.org/shadabahmed/multi_config)

## Description

This `acts_as` style extension provides the capabilities for using multiple database configuration files. Any model can
specify what database config file to use by using a Rails 3.2 style self.config_file= method.

## Installation

In your Gemfile:

    gem 'multi_config'

Or, from the command line:

    gem install multi_config

## Example

    class DifferentTable < ActiveRecord::Base
      self.config_file = 'other_db'
    end

    # In config/other_db.yml

    development: &development
      database: db/other_db
      host: localhost
      adapter: sqlite3

    test:
      <<: *development

## Notes
All database config files should be similar to the database.yml. You need to specify configuration for all the environments
in use like you would specify in database.yml.

ActiveRecord uses *ActiveRecord::Base.configurations* hash to store configurations. This extension modifies the *configurations*
hash by adding the configurations from the other database files. The keys for the configuration in the other config are namespaced.
For e.g. if you specify `other_db` config file with environments `test` and `development` then configurations hash would have
these configs in `other_db_test` and `other_db_development` keys.

If you need to create migrations for the other db, then you will have to make modifications in the migration file. See this
[guide](http://stackoverflow.com/questions/1404620/using-rails-migration-on-different-database-than-standard-production-or-devel) on
how to do that. The parameter for `establish_connection` would be the namespaced key for you config.

## Versions
All versions require Rails 3.0.x and higher.

## Roadmap

1. Add support for generators where you can specify which db file to use in the rails generate command. Would mitigate the need to manually modify migrations.
2. Support for Rails 4

## Contributing to `multi_config`

- Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
- Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
- Fork the project
- Start a feature/bugfix branch
- Commit and push until you are happy with your contribution
- Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
- Send me a pull request
- Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Development
 - Run tests - `rake`
 - Generate test coverage report - `rake coverage`. Coverage report path - coverage/index.html
 - Generate documentation - `rake rdoc`

## Copyright

Copyright (c) 2012 Shadab Ahmed, released under the MIT license