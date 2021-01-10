# frozen_string_literal: true

require_relative "../converter"
require_relative "../formatter"

module TTY
  class ProgressBar
    # Used by {Pipeline} to format :eta token
    #
    # @api private
    class EstimatedFormatter
      include TTY::ProgressBar::Formatter[/:eta/.freeze]

      # Format :eta token
      #
      # @param [String] value
      #  the value to format
      #
      # @api public
      def call(value)
        if @progress.indeterminate?
          return value.gsub(matcher, "--s")
        end

        elapsed = @progress.elapsed_time
        estimated = (elapsed / @progress.ratio).to_f - elapsed
        estimated = (estimated.infinite? || estimated < 0) ? 0.0 : estimated
        value.gsub(matcher, Converter.to_time(estimated))
      end
    end # ElapsedFormatter
  end # ProgressBar
end # TTY
