# frozen_string_literal: true

require_relative '../converter'

module TTY
  class ProgressBar
    # Used by {Pipeline} to format :byte and :current_byte tokens
    #
    # @api private
    class ByteFormatter
      MATCHER = /(:current_byte|:byte)\b/i.freeze

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

      def format(value)
        bytes = Converter.to_bytes(@progress.current)
        value.gsub(MATCHER, bytes)
      end
    end # ByteFormatter
  end # ProgressBar
end # TTY
