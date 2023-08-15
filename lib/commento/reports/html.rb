# frozen_string_literal: true

module Commento
  module Reports
    class Html < Commento::Report
      private

      def main_template
        [
          '<!DOCTYPE html>',
          '<html>',
          '  <head>',
          "    #{styles}",
          '    <meta charset="utf-8" />',
          '  </head>',
          '  <body>',
          '%tables_placeholder%',
          '  </body>',
          '</html>'
        ].join("\n")
      end

      def table_template
        [
          "    <div class='table'>",
          "      <div class='table-header'>",
          '        <h3>%table_name%</h3>',
          '        <p>%table_comment%</p>',
          '      </div>',
          "      <div class='table-body'>",
          '%columns_placeholder%',
          '      </div>',
          "    </div>\n"
        ].join("\n")
      end

      def column_template
        [
          "          <div class='column-body'>",
          '            <p>%column_name%: %column_comment%</p>',
          "            <div class='column-data'>",
          '%data_placeholder%',
          '            </div>',
          "          </div>\n"
        ].join("\n")
      end

      def data_template
        '            <span>%commento_data%</span>'
      end

      def template_format
        'html'
      end

      def styles
        [
          '<style>',
          'h3 { margin: 0 0 .25rem }',
          'p { margin: 0 0 .5rem }',
          '.table { padding: 0 .5rem; margin-bottom: 1rem }',
          '.table-header { border-bottom: 1px solid #ddd; margin-bottom: .5rem }',
          '.table-header h3 { padding: .25rem; background: #bbb }',
          '.table-header p { padding: .25rem; margin: 0 }',
          '.table-body { padding: 0 .25rem }',
          '.column-body { margin-bottom: .5rem; }',
          '.column-body p { margin: 0 }',
          '.column-data { display: flex; flex-direction: column; margin: .5rem 0 }',
          '.column-data span { font-style: italic; padding-left: 1rem }',
          '</style>'
        ].join
      end
    end
  end
end
