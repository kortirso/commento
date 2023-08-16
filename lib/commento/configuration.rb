# frozen_string_literal: true

module Commento
  class Configuration
    attr_accessor :adapter, :include_folders, :exclude_folders, :skip_table_names, :skip_column_names

    def initialize
      @adapter = nil
      @include_folders = %w[app lib]
      @exclude_folders = ['app/assets']
      @skip_table_names = %w[ar_internal_metadata schema_migrations]
      @skip_column_names = %w[id uuid created_at updated_at]
    end
  end
end
