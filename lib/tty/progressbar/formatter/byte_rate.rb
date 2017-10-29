# frozen_string_literal: true

require_relative '../converter'

module TTY
  class ProgressBar
    # Used by {Pipeline} to format :byte_rate token
    #
    # @api private
    class ByteRateFormatter
      MATCHER = /:byte_rate/i

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

      # Format :byte_rate token
      #
      # @param [String] value
      #  the value being formatted
      #
      # @api public
      def format(value)
        formatted = Converter.to_bytes(@progress.rate)
        value.gsub(MATCHER, formatted)
      end
    end # ByteRateFormatter
  end # ProgressBar
end # TTY
