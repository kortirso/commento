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

      # Public: Sets comment for table.
      def set_table_comment(table_name, value)
        sql = "COMMENT ON TABLE #{table_name} IS "
        sql += value ? "'#{value}'" : 'NULL'
        execute(sql)
      end

      # Public: Returns comment for table.
      def get_table_comment(table_name)
        table_data = execute(get_tables_comments_sql).to_a.find { |table_data| table_data['table_name'] == table_name }
        table_data.present? ? table_data['obj_description'] : nil
      end

      # Public: Sets comment for table's column.
      def set_column_comment(table_name, column_name, value)
        sql = "COMMENT ON COLUMN #{table_name}.#{column_name} IS "
        sql += value ? "'#{value}'" : 'NULL'
        execute(sql)
      end

      # Public: Returns comment for table's column.
      def get_column_comment(table_name, column_name)
        sql = get_columns_comments_sql(table_name)
        column_data = execute(sql).to_a.find { |column_data| column_data['column_name'].to_sym == column_name }
        column_data.present? ? column_data['col_description'] : nil
      end

      private

      def get_tables_comments_sql
        <<-SQL.squish
          SELECT
            tables.table_name,
            pg_catalog.obj_description(pgc.oid, 'pg_class')
          FROM information_schema.tables tables
          INNER JOIN pg_catalog.pg_class pgc ON tables.table_name = pgc.relname 
          WHERE
            tables.table_type='BASE TABLE' AND
            tables.table_schema='public'
        SQL
      end

      def get_columns_comments_sql(table_name)
        <<-SQL.squish
          SELECT
            cols.column_name,
            pg_catalog.col_description(pgc.oid, cols.ordinal_position::int)
          FROM pg_catalog.pg_class pgc, information_schema.columns cols
          WHERE
            cols.table_catalog = '#{Rails.configuration.database_configuration[Rails.env]["database"]}' AND
            cols.table_schema = 'public' AND
            cols.table_name = '#{table_name}' AND
            cols.table_name = pgc.relname
        SQL
      end

      def execute(sql)
        ::ActiveRecord::Base.connection.execute(sql)
      end
    end
  end
end
