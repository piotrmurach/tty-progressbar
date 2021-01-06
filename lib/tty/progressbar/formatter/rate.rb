# frozen_string_literal: true

require_relative "../converter"
require_relative "../formatter"

module TTY
  class ProgressBar
    # Used by {Pipeline} to format :rate token
    #
    # @api private
    class RateFormatter
      include TTY::ProgressBar::Formatter[/:rate/i.freeze]

      # Format :rate token
      #
      # @param [String] value
      #  the value being formatted
      #
      # @api public
      def call(value)
        formatted = Converter.to_seconds(@progress.rate)
        value.gsub(matcher, formatted)
      end
    end # RateFormatter
  end # ProgressBar
end # TTY
