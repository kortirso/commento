# frozen_string_literal: true

module Commento
  module Services
    class DataCollect
      COMMENTO_MATCH_REGEXP = /^[ \t]*# commento:.+$/.freeze

      # @data contains data with next format
      # {
      #   'fantasy_sports.points' => [
      #     'app/services/some_service.rb:11'
      #   ]
      # }
      # key - table_name.column_name
      # values - lines of files where these columns are changed in the code
      def initialize
        @data = {}
      end

      def call
        configuration.include_folders.each { |include_folder| iterate_folder(include_folder) }
        @data
      end

      private

      def iterate_folder(include_folder)
        Dir.glob("#{include_folder}/**/*.rb").each do |filename|
          next if exclude_folders.include?(filename.split('/')[0..-2].join('/'))

          File.open(filename) { |lines| iterate_filelines(lines, filename) }
        end
      end

      def iterate_filelines(lines, filename)
        lines.each.with_index(1) do |line, index|
          next unless COMMENTO_MATCH_REGEXP.match?(line)

          field = line.strip.split('# commento: ')[-1]
          @data[field] ||= []
          @data[field] << "#{filename}:#{index}"
        end
      end

      def exclude_folders
        @exclude_folders ||= configuration.exclude_folders
      end

      def configuration
        Commento.configuration
      end
    end
  end
end
