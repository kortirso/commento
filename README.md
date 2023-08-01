# Commento

Commento provides DSL for Ruby on Rails application for working with database comments.

## Installation

Add this line to your application's Gemfile:
```ruby
gem 'commento'
```

And then execute:
```bash
$ bundle install
```

## Gem configuration

### Initializer

Add configuration line to config/initializers/commento.rb:

#### ActiveRecord

```ruby
require 'commento/adapters/active_record'

Commento.configure do |config|
  config.adapter = Commento::Adapters::ActiveRecord.new
end
```

### Models

Update your application model
```ruby
class ApplicationRecord < ActiveRecord::Base
  include Commento::Helpers
end
```

## Usage

Commento provides helpers for models for setting and getting table's column comments.

### Set table's column comment

```ruby
User.set_column_comment(:email, 'Required field for user authentication')
```

or reset comment by skiping value
```ruby
User.set_column_comment(:email)
```

### Read table's column comment

```ruby
User.get_column_comment(:email)
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
