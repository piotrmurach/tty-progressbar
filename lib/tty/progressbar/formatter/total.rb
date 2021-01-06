# frozen_string_literal: true

require_relative "../formatter"

module TTY
  class ProgressBar
    # Used by {Pipeline} to format :total token
    #
    # @api private
    class TotalFormatter
      include TTY::ProgressBar::Formatter[/:total\b/i.freeze]

      # Format :total token
      #
      # @param [String] value
      #  the value to format
      #
      # @api public
      def call(value)
        display = @progress.indeterminate? ? "-" : @progress.total.to_s
        value.gsub(matcher, display)
      end
    end # TotalFormatter
  end # ProgressBar
end # TTY
