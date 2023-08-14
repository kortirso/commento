# frozen_string_literal: true

module Commento
  class Report
    def create_report
      Dir.mkdir('commento') unless Dir.exist?('commento')
      File.write(
        "commento/index.#{template_format}",
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
        column_template
          .gsub('%column_name%', "#{table_name}.#{column_data[:column_name]}")
          .gsub('%column_comment%', column_data[:column_comment].presence || '')
      end.join
    end

    def database_comments
      adapter.comments_for_database
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

    def template_format
      raise NotImplementedError
    end

    def adapter
      Commento.adapter
    end
  end
end
