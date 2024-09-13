# frozen_string_literal: true

module Commento
  class Report
    COMMENTO_FOLDER_NAME = 'commento'

    def initialize(data_scraper: Commento::Scrapers::Ruby.new)
      @data_scraper = data_scraper
    end

    def create_report
      @commento_data = @data_scraper.call
      FileUtils.mkdir_p(COMMENTO_FOLDER_NAME)
      File.write(
        "#{COMMENTO_FOLDER_NAME}/#{file_name}",
        main_template.gsub('%tables_placeholder%', tables_placeholder)
      )
    end

    private

    def tables_placeholder
      database_comments.map do |table_data|
        table_template
          .gsub('%table_name%', table_data[:table_name])
          .gsub('%table_comment%', table_data[:table_comment].presence || '')
          .gsub('%columns_placeholder%', columns_placeholder(table_data[:table_name], table_data[:columns]))
      end.join
    end

    def columns_placeholder(table_name, columns)
      columns.map do |column_data|
        full_column_name = "#{table_name}.#{column_data[:column_name]}"
        column_template
          .gsub('%column_name%', column_data[:column_name])
          .gsub('%column_comment%', column_data[:column_comment].presence || '')
          .gsub('%data_placeholder%', data_placeholder(full_column_name))
      end.join
    end

    def data_placeholder(full_column_name)
      return '' if @commento_data[full_column_name].blank?

      @commento_data[full_column_name].map do |filename|
        data_template.gsub('%commento_data%', filename)
      end.join
    end

    def database_comments
      adapter.fetch_comments_for_database
    end

    def main_template
      raise NotImplementedError
    end

    def table_template
      raise NotImplementedError
    end

    def column_template
      raise NotImplementedError
    end

    def data_template
      raise NotImplementedError
    end

    def file_name
      raise NotImplementedError
    end

    def adapter
      Commento.adapter
    end
  end
end
