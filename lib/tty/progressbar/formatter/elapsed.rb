# frozen_string_literal: true

require_relative "../converter"
require_relative "../formatter"

module TTY
  class ProgressBar
    # Used by {Pipeline} to format :elapsed token
    #
    # @api private
    class ElapsedFormatter
      include TTY::ProgressBar::Formatter[/:elapsed/.freeze]

      # Format :elapsed token
      #
      # @param [String] value
      #  the value to format
      #
      # @api public
      def call(value)
        value.gsub(matcher, Converter.to_time(@progress.elapsed_time))
      end
    end # ElapsedFormatter
  end # ProgressBar
end # TTY
