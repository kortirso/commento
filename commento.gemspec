# frozen_string_literal: true

require_relative 'lib/commento/version'

Gem::Specification.new do |spec|
  spec.name = 'commento'
  spec.version = Commento::VERSION
  spec.authors = ['Bogdanov Anton']
  spec.email = ['kortirso@gmail.com']

  spec.summary = 'Work with database comments.'
  spec.description = 'Commento allows to work with database comments.'
  spec.homepage = 'https://github.com/kortirso/commento'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.7.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/kortirso/commento'
  spec.metadata['changelog_uri'] = 'https://github.com/kortirso/commento/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir['{lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rainbow', '>= 2.2.2'
  spec.add_dependency 'terminal-table', '>= 3.0'

  # Uncomment to register a new dependency of your gem
  spec.add_development_dependency 'rubocop', '~> 1.39'
  spec.add_development_dependency 'rubocop-performance', '~> 1.8'
  spec.add_development_dependency 'rubocop-rake', '~> 0.6'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.0'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
