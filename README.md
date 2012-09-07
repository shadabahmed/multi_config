This gem will allow multiple db config files to be used in a Rails 3 project. All you have to do is
```ruby
  class MyTable < ActiveRecord::Base
    self.config_file = 'my_config'
  end
```
