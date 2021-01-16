# frozen_string_literal: true

module TTY
  class ProgressBar
    # Used by {Pipeline} to format :eta_time token
    #
    # @api private
    class EstimatedTimeFormatter
      include TTY::ProgressBar::Formatter[/:eta_time/.freeze]

      # Format :eta_time token
      #
      # @param [String] value
      #   the value to format
      #
      # @api public
      def call(value)
        if @progress.indeterminate?
          return value.gsub(matcher, "--:--:--")
        end

        elapsed = @progress.elapsed_time
        estimated = (elapsed / @progress.ratio).to_f - elapsed
        estimated = (estimated.infinite? || estimated < 0) ? 0.0 : estimated

        time_format = if estimated >= 86_400 # longer than a day
                        "%Y-%m-%d %H:%M:%S"
                      else
                        "%H:%M:%S"
                      end
        completion_time = Time.now + estimated
        eta_time = completion_time.strftime(time_format)
        value.gsub(matcher, eta_time)
      end
    end # EstimatedTimeFormatter
  end # ProgressBar
end # TTY
