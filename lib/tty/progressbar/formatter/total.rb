# frozen_string_literal: true

module TTY
  class ProgressBar
    # Used by {Pipeline} to format :total token
    #
    # @api private
    class TotalFormatter
      MATCHER = /:total\b/i.freeze

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

      # Format :total token
      #
      # @param [String] value
      #  the value to format
      #
      # @api public
      def format(value)
        display = @progress.indeterminate? ? "-" : @progress.total.to_s
        value.gsub(MATCHER, display)
      end
    end # TotalFormatter
  end # ProgressBar
end # TTY
