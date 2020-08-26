require 'rails/generators'

module Moneytree
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.join(__dir__, 'templates')

      def copy_templates
        activerecord = defined?(ActiveRecord)

        selection =
          if activerecord
            puts <<~MSG

              Which data store would you like to use?
               1. ActiveRecord (default)
               2. Mongoid
               3. Neither
            MSG

            ask('>')
          elsif activerecord
            '1'
          elsif mongoid
            '2'
          else
            '3'
          end

        case selection
        when '', '1'
          invoke 'moneytree:activerecord'
        when '2'
          invoke 'moneytree:mongoid'
        when '3'
          invoke 'moneytree:base'
        else
          abort 'Error: must enter a number [1-3]'
        end
      end
    end
  end
end
