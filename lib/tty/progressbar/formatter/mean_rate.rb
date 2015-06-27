# coding: utf-8

module TTY
  class ProgressBar
    # Used by {Pipeline} to format :mean_rate token
    #
    # @api private
    class MeanRateFormatter
      MATCHER = /:mean_rate/i.freeze

      def initialize(progress)
        @progress  = progress
        @converter = Converter.new
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

      # Format :rate token
      #
      # @param [String] value
      #  the value being formatted
      #
      # @api public
      def format(value)
        formatted = @converter.to_seconds(@progress.mean_rate)
        value.gsub(MATCHER, formatted)
      end
    end # MeanRateFormatter
  end # ProgressBar
end # TTY
