# coding: utf-8

module TTY
  class ProgressBar
    # Responsible for converting values to different formats
    #
    # @api public
    class Converter
      def to_time(seconds)
        hours = (seconds / 3600.to_f).floor
        seconds -= hours * 3600
        minutes = (seconds / 60).floor
        seconds -= minutes * 60

        if hours > 99
          sprintf('%dh', hours)
        elsif hours > 0
          sprintf('%2dh%2dm', hours, minutes)
        elsif minutes > 0
          sprintf('%2dm%2ds', minutes, seconds)
        else
          sprintf('%2ds', seconds)
        end
      end
    end # Converter
  end # ProgressBar
end # TTY
