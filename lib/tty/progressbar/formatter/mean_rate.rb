# frozen_string_literal: true

require_relative "../converter"
require_relative "../formatter"

module TTY
  class ProgressBar
    # Used by {Pipeline} to format :mean_rate token
    #
    # @api private
    class MeanRateFormatter
      include TTY::ProgressBar::Formatter[/:mean_rate/i.freeze]

      # Format :mean_rate token
      #
      # @param [String] value
      #  the value being formatted
      #
      # @api public
      def call(value)
        formatted = Converter.to_seconds(@progress.mean_rate)
        value.gsub(matcher, formatted)
      end
    end # MeanRateFormatter
  end # ProgressBar
end # TTY
