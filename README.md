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
  config.include_folders = %w[app lib] # folder for searching commento comments
  config.exclude_folders = ['app/assets'] # folder for excluding searching commento comments
  config.skip_table_names = %w[ar_internal_metadata schema_migrations] # ignoring tables
  config.skip_column_names = %w[id uuid created_at updated_at] # ignoring columns
end
```

## Rake tasks

### Generating reports

You can generate different types of reports (right now only html) with rake task

```bash
rails "commento:generate_report[html]"
```

### Health check

You can check amount of missing comments for tables and columns with console report

```bash
rails commento:health
```

<img width="727" alt="Снимок экрана 2024-09-13 в 10 11 12" src="https://github.com/user-attachments/assets/f0b8fbf8-6a6a-4c7b-b6b6-2a0de6d19f45">

### Generating migration for adding comments to tables and columns

You can generate migration with adding comments for table and columns

```bash
rails g commento:active_record
```

## Usage

Commento provides helpers for models for setting and getting comments.

### Models configuration

Update your application model

```ruby
class ApplicationRecord < ActiveRecord::Base
  include Commento::Helpers
end
```

### Set table's comment

```ruby
User.set_table_comment('Users table')
```

or reset comment by skiping value
```ruby
User.set_table_comment
```

### Read table's comment

```ruby
User.fetch_table_comment
```

### Set column's comment

```ruby
User.set_column_comment(:email, 'Required field for user authentication')
```

or reset comment by skiping value
```ruby
User.set_column_comment(:email)
```

### Read column's comment

```ruby
User.fetch_column_comment(:email)
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
