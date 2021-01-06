# frozen_string_literal: true

require_relative "../converter"
require_relative "../formatter"

module TTY
  class ProgressBar
    # Used by {Pipeline} to format :byte_rate token
    #
    # @api private
    class ByteRateFormatter
      include TTY::ProgressBar::Formatter[/:byte_rate/i.freeze]

      # Format :byte_rate token
      #
      # @param [String] value
      #  the value to format
      #
      # @api public
      def call(value)
        formatted = Converter.to_bytes(@progress.rate)
        value.gsub(matcher, formatted)
      end
    end # ByteRateFormatter
  end # ProgressBar
end # TTY
