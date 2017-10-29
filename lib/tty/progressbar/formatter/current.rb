# frozen_string_literal: true

module TTY
  class ProgressBar
    # Used by {Pipeline} to format :current token
    #
    # @api private
    class CurrentFormatter
      MATCHER = /:current\b/i.freeze

      def initialize(progress)
        @progress = progress
      end

      # Determines whether this formatter is applied or not.
      #
      # @param [Object] value
      #
      # @return [Boolean]
      #
      # @api private
      def matches?(value)
        !!(value.to_s =~ MATCHER)
      end

      # Format :current token
      #
      # @param [String] value
      #  the value being formatted
      #
      # @api public
      def format(value)
        value.gsub(MATCHER, @progress.current.to_s)
      end
    end # CurrentFormatter
  end # ProgressBar
end # TTY
