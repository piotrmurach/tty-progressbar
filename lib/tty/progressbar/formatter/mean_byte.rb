# frozen_string_literal: true

require_relative "../converter"
require_relative "../formatter"

module TTY
  class ProgressBar
    # Used by {Pipeline} to format :mean_byte token
    #
    # @api private
    class MeanByteFormatter
      include TTY::ProgressBar::Formatter[/:mean_byte/i.freeze]

      # Format :mean_byte token
      #
      # @param [String] value
      #  the value being formatted
      #
      # @api public
      def call(value)
        formatted = Converter.to_bytes(@progress.mean_rate)
        value.gsub(matcher, formatted)
      end
    end # MeanByteFormatter
  end # ProgressBar
end # TTY
