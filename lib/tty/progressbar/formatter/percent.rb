# frozen_string_literal: true

module TTY
  class ProgressBar
    # Used by {Pipeline} to format :percent token
    #
    # @api private
    class PercentFormatter
      MATCHER = /:percent\b/.freeze

      def initialize(progress, *args, &block)
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

      def format(value)
        percent = @progress.width == 0 ? 100 : (@progress.ratio * 100).to_i
        value.gsub(MATCHER, percent.to_s + '%')
      end
    end # PercentFormatter
  end # ProgressBar
end # TTY
