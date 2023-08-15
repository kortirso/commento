# frozen_string_literal: true

module Commento
  class Report
    def create_report
      collect_commento_data
      FileUtils.mkdir_p('commento')
      File.write(
        "commento/index.#{template_format}",
        main_template.gsub('%tables_placeholder%', tables_placeholder)
      )
    end

    private

    # rubocop: disable Metrics/AbcSize
    # TODO: extract method to separate class
    def collect_commento_data
      @commento_data = {}
      exclude_folders = configuration.exclude_folders
      configuration.include_folders.each do |include_folder|
        Dir.glob("#{include_folder}/**/*.rb").each do |filename|
          next if exclude_folders.include?(filename.split('/')[0..-2].join('/'))

          File.open(filename) do |f|
            f.each.with_index(1) do |line, index|
              next unless /^[ \t]*# commento:.+$/.match?(line)

              field = line.strip.split('# commento: ')[-1]
              @commento_data[field] ||= []
              @commento_data[field] << "#{filename}:#{index}"
            end
          end
        end
      end
    end
    # rubocop: enable Metrics/AbcSize

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
          .gsub('%column_name%', full_column_name)
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

    def data_template
      raise NotImplementedError
    end

    def template_format
      raise NotImplementedError
    end

    def adapter
      Commento.adapter
    end

    def configuration
      Commento.configuration
    end
  end
end
