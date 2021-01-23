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
        if @progress.indeterminate? ||
           (@progress.elapsed_time.zero? && @progress.ratio.zero?)
          return value.gsub(matcher, "--s")
        end

        elapsed = @progress.elapsed_time
        estimated = @progress.ratio.zero? ? 0.0 : (elapsed / @progress.ratio).to_f
        estimated -= elapsed
        estimated = 0.0 if estimated < 0
        value.gsub(matcher, Converter.to_time(estimated))
      end
    end # EstimatedFormatter
  end # ProgressBar
end # TTY
