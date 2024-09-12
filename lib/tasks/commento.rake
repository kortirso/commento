# frozen_string_literal: true

require 'commento'

AVAILABLE_REPORT_FORMATS = %w[html].freeze

namespace :commento do
  desc 'Generates HTML report'
  task :generate_report, [:format] => :environment do |_, args|
    if args[:format].blank?
      puts 'Please specify format'
      next
    end

    unless args[:format].in?(AVAILABLE_REPORT_FORMATS)
      puts 'Format is not supported, available options: html'
      next
    end

    case args[:format]
    when 'html' then Commento::Reports::Html.new.create_report
    end

    puts 'Report is generated'
  end
end
