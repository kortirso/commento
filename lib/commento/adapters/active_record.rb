# frozen_string_literal: true

require 'active_record'

module Commento
  module Adapters
    class ActiveRecord
      # Public: The name of the adapter.
      attr_reader :name

      # Public: Initialize a new ActiveRecord adapter instance.
      #
      # name - The Symbol name for this adapter. Optional (default :active_record)
      def initialize(options={})
        @name = options.fetch(:name, :active_record)
      end

      # Public: Sets comment for table's column.
      def set_column_comment(table_name, column_name, value)
        sql = "COMMENT ON COLUMN #{table_name}.#{column_name} IS "
        sql += value ? "'#{value}'" : 'NULL'
        execute(sql)
      end

      # Public: Returns comment for table's column.
      def get_column_comment(table_name, column_name)
        sql = <<-SQL.squish
          SELECT
            cols.column_name,
            pg_catalog.col_description(c.oid, cols.ordinal_position::int)
          FROM pg_catalog.pg_class c, information_schema.columns cols
          WHERE
            cols.table_catalog = '#{Rails.configuration.database_configuration[Rails.env]["database"]}' AND
            cols.table_schema = 'public' AND
            cols.table_name = '#{table_name}' AND
            cols.table_name = c.relname
        SQL
        column_data = execute(sql).to_a.find { |column| column['column_name'].to_sym == column_name }
        column_data.presence ? column_data['col_description'] : nil
      end

      private

      def execute(sql)
        ::ActiveRecord::Base.connection.execute(sql)
      end
    end
  end
end
