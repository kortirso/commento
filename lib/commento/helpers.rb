# frozen_string_literal: true

module Commento
  module Helpers
    def self.included(base)
      base.class_eval do
        extend ClassMethods
      end
    end

    module ClassMethods
      def set_column_comment(column_name, value=nil)
        instance.set_column_comment(table_name, column_name, value)
      end

      def get_column_comment(column_name)
        instance.get_column_comment(table_name, column_name)
      end

      def instance
        Commento.instance
      end
    end
  end
end
