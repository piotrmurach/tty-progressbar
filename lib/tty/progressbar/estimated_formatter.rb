# coding: utf-8

module TTY
  class ProgressBar
    # Used by {Pipeline} to format :eta token
    #
    # @api private
    class EstimatedFormatter
      def initialize(progress)
        @progress  = progress
        @converter = Converter.new
      end

      def format(value)
        elapsed   = Time.now - @progress.start_at
        estimated = (elapsed / @progress.ratio).to_f - elapsed
        estimated = (estimated.infinite? || estimated < 0) ? 0.0 : estimated
        value.gsub(/:eta/, @converter.to_time(estimated))
      end
    end # ElapsedFormatter
  end # ProgressBar
end # TTY
