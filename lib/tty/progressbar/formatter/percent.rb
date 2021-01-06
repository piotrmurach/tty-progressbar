# frozen_string_literal: true

require_relative "../formatter"

module TTY
  class ProgressBar
    # Used by {Pipeline} to format :percent token
    #
    # @api private
    class PercentFormatter
      include TTY::ProgressBar::Formatter[/:percent\b/.freeze]

      # Format :percent token
      #
      # @param [String] value
      #  the value to format
      #
      # @api public
      def call(value)
        percent = @progress.width == 0 ? 100 : (@progress.ratio * 100).to_i
        display = @progress.indeterminate? ? "-" : percent.to_s
        value.gsub(matcher, "#{display}%")
      end
    end # PercentFormatter
  end # ProgressBar
end # TTY
