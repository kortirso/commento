# frozen_string_literal: true

require 'rails/generators/active_record'

module Commento
  module Generators
    class ActiveRecordGenerator < ::Rails::Generators::Base
      include ::Rails::Generators::Migration

      desc 'Generates migration for adding comments'

      source_paths << File.join(File.dirname(__FILE__), 'templates')

      attr_reader :tables_change_data, :columns_change_data

      def self.next_migration_number(dirname)
        ::ActiveRecord::Generators::Base.next_migration_number(dirname)
      end

      def self.migration_version
        "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]" if requires_migration_number?
      end

      def self.requires_migration_number?
        Rails::VERSION::MAJOR.to_i >= 5
      end

      def create_migration_file
        generate_migration_data

        migration_template 'migration.erb', 'db/migrate/commento_add_comments_to_tables_and_columns.rb'
      end

      def migration_version
        self.class.migration_version
      end

      def generate_migration_data
        @tables_without_comment = []
        @table_report = {}

        check_comments_for_database(Commento.adapter.fetch_comments_for_database)

        @tables_change_data =
          @tables_without_comment
          .map { |table_name| "change_table_comment(:#{table_name}, from: nil, to: '')" }
          .join("\n    ")

        @columns_change_data =
          @table_report.map do |table_name, column_names|
            column_names.map do |column_name|
              "change_column_comment(:#{table_name}, :#{column_name}, from: nil, to: '')"
            end
          end.flatten.join("\n    ")
      end

      private

      def check_comments_for_database(comments_for_database)
        comments_for_database.each do |table_data|
          @tables_without_comment << table_data[:table_name] if table_data[:table_comment].nil?
          table_data[:columns].each do |column_data|
            next if column_data[:column_comment].present?

            @table_report[table_data[:table_name]] ||= []
            @table_report[table_data[:table_name]] << column_data[:column_name]
          end
        end
      end
    end
  end
end
