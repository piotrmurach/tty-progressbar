# frozen_string_literal: true

require_relative '../converter'

module TTY
  class ProgressBar
    # Used by {Pipeline} to format :mean_byte token
    #
    # @api private
    class MeanByteFormatter
      MATCHER = /:mean_byte/i.freeze

      def initialize(progress)
        @progress  = progress
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
        formatted = Converter.to_bytes(@progress.mean_rate)
        value.gsub(MATCHER, formatted)
      end
    end # MeanByteFormatter
  end # ProgressBar
end # TTY
