# frozen_string_literal: true

module TTY
  class ProgressBar
    # Responsible for converting values to different formats
    #
    # @api public
    module Converter
      HOURSECONDS = 3600

      # Convert seconds to time notation
      #
      # @param [Numeric] seconds
      #   the seconds to convert to time
      #
      # @api public
      def to_time(seconds)
        days = (seconds / (24 * HOURSECONDS).to_f).floor
        seconds -= days * 24 * HOURSECONDS
        hours = (seconds / HOURSECONDS.to_f).floor
        seconds -= hours * HOURSECONDS
        minutes = (seconds / 60).floor
        seconds -= minutes * 60

        if days > 0 # over 24 hours switch to days
          format("%dd%2dh%2dm", days, hours, minutes)
        elsif hours > 0
          format("%2dh%2dm", hours, minutes)
        elsif minutes > 0
          format("%2dm%2ds", minutes, seconds)
        else
          format("%2ds", seconds)
        end
      end
      module_function :to_time

      # Convert seconds to set precision
      #
      # @param [Numeric] seconds
      #   the seconds to convert
      #
      # @return [String]
      #   the formatted result
      #
      # @api public
      def to_seconds(seconds, precision: nil)
        precision ||= (seconds < 1 && !seconds.zero?) ? 5 : 2
        format "%5.#{precision}f", seconds
      end
      module_function :to_seconds

      BYTE_UNITS = %w[b kb mb gb tb pb eb].freeze

      # Convert value to bytes
      #
      # @param [Numeric] value
      #   the value to convert to bytes
      # @param [Integer] decimals
      #   the number of decimals parts
      # @param [String] separator
      #   the separator to use for thousands in a number
      # @param [String] unit_separator
      #   the separtor to use between number and unit
      #
      # @return [String]
      #
      # @api public
      def to_bytes(value, decimals: 2, separator: ".", unit_separator: "")
        base    = 1024
        pattern = "%.#{decimals}f"

        unit = BYTE_UNITS.find.with_index { |_, i| value < base**(i + 1) }

        if value < base
          formatted_value = value.to_i.to_s
        else
          value_to_size = value / (base**BYTE_UNITS.index(unit)).to_f
          formatted_value = format(pattern, value_to_size)
        end

        formatted_value.gsub(/\./, separator) + unit_separator + unit.to_s.upcase
      end
      module_function :to_bytes
    end # Converter
  end # ProgressBar
end # TTY
