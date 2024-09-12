# frozen_string_literal: true

require 'commento'
require 'rails'

module Commento
  class Railtie < Rails::Railtie
    railtie_name :commento

    rake_tasks do
      path = File.expand_path(__dir__)
      Dir.glob("#{path}/../tasks/**/*.rake").each { |f| load f }
    end
  end
end
