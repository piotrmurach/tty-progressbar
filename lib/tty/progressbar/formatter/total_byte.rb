# frozen_string_literal: true

require_relative "../converter"

module TTY
  class ProgressBar
    # Used by {Pipeline} to format :total_byte token
    #
    # @api private
    class TotalByteFormatter
      MATCHER = /:total_byte/i.freeze

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

      # Format :total_byte token
      #
      # @param [String] value
      #  the value to format
      #
      # @api public
      def format(value)
        bytes = if @progress.indeterminate?
                  "-B"
                else
                  Converter.to_bytes(@progress.total)
                end
        value.gsub(MATCHER, bytes)
      end
    end # TotalByteFormatter
  end # ProgressBar
end # TTY
