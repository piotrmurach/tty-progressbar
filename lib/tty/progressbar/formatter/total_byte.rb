# frozen_string_literal: true

require_relative "../converter"
require_relative "../formatter"

module TTY
  class ProgressBar
    # Used by {Pipeline} to format :total_byte token
    #
    # @api private
    class TotalByteFormatter
      include TTY::ProgressBar::Formatter[/:total_byte/i.freeze]

      # Format :total_byte token
      #
      # @param [String] value
      #  the value to format
      #
      # @api public
      def call(value)
        bytes = if @progress.indeterminate?
                  "-B"
                else
                  Converter.to_bytes(@progress.total)
                end
        value.gsub(matcher, bytes)
      end
    end # TotalByteFormatter
  end # ProgressBar
end # TTY
