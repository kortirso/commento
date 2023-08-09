# frozen_string_literal: true

module Commento
  class DSL
    attr_reader :adapter

    # Public: Returns a new instance of the DSL.
    #
    # adapter - The adapter that this DSL instance should use.
    def initialize(adapter)
      @adapter = adapter
    end

    # Public: Sets comment for table.
    def set_table_comment(table_name, value)
      adapter.set_table_comment(table_name, value)
    end

    # Public: Returns comment for table.
    def table_comment(table_name)
      adapter.table_comment(table_name)
    end

    # Public: Sets comment for table's column.
    def set_column_comment(table_name, column_name, value)
      adapter.set_column_comment(table_name, column_name, value)
    end

    # Public: Returns comment for table's column.
    def column_comment(table_name, column_name)
      adapter.column_comment(table_name, column_name)
    end
  end
end
