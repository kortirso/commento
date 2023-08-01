# frozen_string_literal: true

require 'forwardable'

require 'commento/version'
require 'commento/configuration'
require 'commento/dsl'
require 'commento/helpers'

module Commento
  extend self
  extend Forwardable

  # Public: Given an adapter returns a handy DSL to all the commentp goodness.
  def new(adapter)
    DSL.new(adapter)
  end

  # Public: Configure commentp.
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

  # Public: Default per thread commentp instance if configured.
  # Returns Commento::DSL instance.
  def instance
    Thread.current[:commento_instance] ||= new(configuration.adapter)
  end

  # Public: All the methods delegated to instance. These should match the interface of Commento::DSL.
  def_delegators :instance, :adapter
end