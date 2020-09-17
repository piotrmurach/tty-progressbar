# frozen_string_literal: true

module TTY
  class ProgressBar
    class Formatter < ::Module
      # A helper for declaring a matching token pattern
      #
      # @api public
      def self.[](token_match)
        new(token_match)
      end

      # Initialize this module with token matching pattern
      #
      # @param [Regexp] token_match
      #   the token matching pattern
      #
      # @api public
      def initialize(token_match)
        pattern = token_match

        module_eval do
          define_method(:initialize) do |progress|
            @progress = progress
          end

          define_method(:matcher) { pattern }
          define_method(:progress) { @progress }

          # Determines whether this formatter is applied or not.
          #
          # @param [Object] value
          #
          # @return [Boolean]
          #
          # @api private
          define_method(:matches?) do |value|
            !!(value.to_s =~ pattern)
          end
        end
      end
    end # Formatter
  end # ProgressBar
end # TTY
