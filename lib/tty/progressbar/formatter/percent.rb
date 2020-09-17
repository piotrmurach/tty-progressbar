# frozen_string_literal: true

module TTY
  class ProgressBar
    # Used by {Pipeline} to format :percent token
    #
    # @api private
    class PercentFormatter
      MATCHER = /:percent\b/.freeze

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

      # Format :percent token
      #
      # @param [String] value
      #  the value to format
      #
      # @api public
      def format(value)
        percent = @progress.width == 0 ? 100 : (@progress.ratio * 100).to_i
        display = @progress.indeterminate? ? "-" : percent.to_s
        value.gsub(MATCHER, display + "%")
      end
    end # PercentFormatter
  end # ProgressBar
end # TTY
