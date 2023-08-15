# frozen_string_literal: true

module Commento
  class Configuration
    attr_accessor :adapter, :include_folders, :exclude_folders

    def initialize
      @adapter = nil
      @include_folders = %w[app lib]
      @exclude_folders = ['app/assets']
    end
  end
end
