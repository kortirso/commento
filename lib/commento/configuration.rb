# frozen_string_literal: true

module Commento
  class Configuration
    attr_accessor :adapter

    def initialize
      @adapter = nil
    end
  end
end
