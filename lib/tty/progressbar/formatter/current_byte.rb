# frozen_string_literal: true

require_relative "../converter"
require_relative "../formatter"

module TTY
  class ProgressBar
    # Used by {Pipeline} to format :byte and :current_byte tokens
    #
    # @api private
    class ByteFormatter
      include TTY::ProgressBar::Formatter[/(:current_byte|:byte)\b/i.freeze]

      # Format :current_byte token
      #
      # @param [String] value
      #  the value to format
      #
      # @api public
      def call(value)
        bytes = Converter.to_bytes(@progress.current)
        value.gsub(matcher, bytes)
      end
    end # ByteFormatter
  end # ProgressBar
end # TTY
