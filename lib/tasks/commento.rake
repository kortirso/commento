# frozen_string_literal: true

require 'commento'
require 'rainbow'
require 'terminal-table'

AVAILABLE_REPORT_FORMATS = %w[html].freeze

# rubocop: disable Metrics/BlockLength
namespace :commento do
  desc 'Generates HTML report'
  task :generate_report, [:format] => :environment do |_, args|
    if args[:format].blank?
      puts Rainbow('Please specify format').red.bright
      next
    end

    unless args[:format].in?(AVAILABLE_REPORT_FORMATS)
      puts Rainbow("Format is not supported, available options: #{AVAILABLE_REPORT_FORMATS.join(", ")}").red.bright
      next
    end

    puts Rainbow('Generating report is started').green

    case args[:format]
    when 'html' then Commento::Reports::Html.new.create_report
    end

    puts Rainbow('✓ Good job! Report is generated').green.bright
  end

  desc 'Generates console report about missing table and column comments'
  task health: :environment do
    puts Rainbow("Starting commento health check\n").green

    comments_for_database = Commento.adapter.fetch_comments_for_database

    tables_with_comment_amount = 0
    tables_without_comment = []
    tables_without_comment_amount = 0
    columns_with_comment_amount = 0
    columns_without_comment_amount = 0

    table_report_with_missing_comments = {}

    comments_for_database.each do |table_data|
      if table_data[:table_comment].nil?
        tables_without_comment << table_data[:table_name]
        tables_without_comment_amount += 1
        table_report_with_missing_comments[table_data[:table_name]] = []
      else
        tables_with_comment_amount += 1
      end
      table_data[:columns].each do |column_data|
        if column_data[:column_comment].nil?
          columns_without_comment_amount += 1
          table_report_with_missing_comments[table_data[:table_name]] ||= []
          table_report_with_missing_comments[table_data[:table_name]] << column_data[:column_name]
        else
          columns_with_comment_amount += 1
        end
      end
    end

    total_tables_amount = tables_with_comment_amount + tables_without_comment_amount
    tables_with_comment_ratio = total_tables_amount.zero? ? 0 : (tables_with_comment_amount * 100 / total_tables_amount)

    if tables_with_comment_ratio == 100
      puts Rainbow('✓ Amazing! All tables have comment').green.bright
    elsif tables_with_comment_ratio > 50
      puts Rainbow("✓ Good job! #{tables_with_comment_ratio}% of tables have comment").green.bright
    elsif tables_with_comment_ratio.positive?
      puts Rainbow("✓ Need to work! Only #{tables_with_comment_ratio}% of tables have comment").yellow.bright
    else
      puts Rainbow('✓ Something is missing! No single table have comment').red.bright
    end

    total_columns_amount = columns_with_comment_amount + columns_without_comment_amount
    columns_ratio = total_columns_amount.zero? ? 0 : (columns_with_comment_amount * 100 / total_columns_amount)

    if columns_ratio == 100
      puts Rainbow('✓ Amazing! All columns have comment').green.bright
    elsif columns_ratio > 50
      puts Rainbow("✓ Good job! #{columns_ratio}% of columns have comment").green.bright
    elsif columns_ratio.positive?
      puts Rainbow("✓ Need to work! Only #{columns_ratio}% of columns have comment").yellow.bright
    else
      puts Rainbow('✓ Something is missing! No single column have comment').red.bright
    end

    if tables_without_comment_amount.positive? || columns_without_comment_amount.positive?
      rows = []
      table_report_with_missing_comments.each do |table_name, column_names|
        rows << [
          table_name.in?(tables_without_comment) ? Rainbow(table_name).cyan.bright : Rainbow(table_name).silver.bright,
          column_names.map { |column_name| Rainbow(column_name).cyan.bright }.join("\n")
        ]
        rows << :separator
      end
      puts ''
      puts Terminal::Table.new(
        title: Rainbow('Missing comments report').silver.bright,
        headings: [Rainbow('Table name').silver.bright, Rainbow('Column name').silver.bright],
        rows: rows,
        style: { width: 80, border_bottom: false }
      )
    end
  end
end
# rubocop: enable Metrics/BlockLength
