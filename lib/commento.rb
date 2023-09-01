# frozen_string_literal: true

require 'forwardable'

require 'commento/version'
require 'commento/configuration'
require 'commento/dsl'
require 'commento/helpers'
require 'commento/report'
require 'commento/reports/html'
require 'commento/scrapers/ruby'

module Commento
  extend self
  extend Forwardable

  # Public: Given an adapter returns a handy DSL to all the commento goodness.
  def new(adapter)
    DSL.new(adapter)
  end

  # Public: Configure commento.
  #
  #   Commento.configure do |config|
  #     config.adapter = Commento::Adapters::ActiveRecord.new
  #   end
  #
  def configure
    yield configuration
  end

  # Public: Returns Commento::Configuration instance.
  def configuration
    @configuration ||= Configuration.new
  end

  # Public: Default per thread commento instance if configured.
  # Returns Commento::DSL instance.
  def instance
    Thread.current[:commento_instance] ||= new(configuration.adapter)
  end

  # Public: All the methods delegated to instance. These should match the interface of Commento::DSL.
  def_delegators :instance, :adapter
end
