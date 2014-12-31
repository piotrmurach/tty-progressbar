# coding: utf-8

module TTY
  class ProgressBar
    # Responsible for converting values to different formats
    #
    # @api public
    class Converter
      HOURSECONDS = 3600

      # Convert seconds to time notation
      #
      # @param [Numeric] seconds
      #   the seconds to convert to time
      #
      # @api public
      def to_time(seconds)
        hours = (seconds / HOURSECONDS.to_f).floor
        seconds -= hours * HOURSECONDS
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

      # Convert seconds to set precision
      #
      # @param [Numeric] seconds
      #   the seconds to convert
      #
      # @return [String]
      #   the formatted result
      #
      # @api public
      def to_seconds(seconds, precision = nil)
        precision ||= (seconds < 1 && !seconds.zero?) ? 5 : 2
        sprintf "%5.#{precision}f", seconds
      end

      KILOBYTE = 1024
      MEGABYTE = KILOBYTE * 1024
      GIGABYTE = MEGABYTE * 1024

      # Convert value to bytes
      #
      # @param [Numeric] value
      #   the value to convert to bytes
      #
      # @return [String]
      #
      # @api public
      def to_bytes(value)
        if value >= GIGABYTE
          sprintf('%.2f', value / GIGABYTE.to_f) + 'GB'
        elsif value >= MEGABYTE
          sprintf('%.2f', value / MEGABYTE.to_f) + 'MB'
        elsif value >= KILOBYTE
          sprintf('%.2f', value / KILOBYTE.to_f) + 'KB'
        else
          value.to_s + 'B'
        end
      end
    end # Converter
  end # ProgressBar
end # TTY
