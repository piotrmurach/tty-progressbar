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
      def to_seconds(seconds, precision = nil)
        precision ||= (seconds < 1 && !seconds.zero?) ? 5 : 2
        sprintf "%5.#{precision}f", seconds
      end
      module_function :to_seconds

      BYTE_UNITS = %w(b kb mb gb tb pb eb).freeze

      # Convert value to bytes
      #
      # @param [Numeric] value
      #   the value to convert to bytes
      # @param [Hash[Symbol]] options
      # @option [Integer] :decimals
      #   the number of decimals parts
      # @option [String] :separator
      #   the separator to use for thousands in a number
      # @option [String] :unit_separator
      #   the separtor to use between number and unit
      #
      # @return [String]
      #
      # @api public
      def to_bytes(value, options = {})
        decimals       = options.fetch(:decimals) { 2 }
        separator      = options.fetch(:separator) { '.' }
        unit_separator = options.fetch(:unit_separator) { '' }

        base    = 1024
        pattern = "%.#{decimals}f"

        unit = BYTE_UNITS.find.with_index { |_, i| value < base ** (i + 1) }

        if value < base
          formatted_value = value.to_i.to_s
        else
          value_to_size = value / (base ** BYTE_UNITS.index(unit)).to_f
          formatted_value = format(pattern, value_to_size)
        end

        formatted_value.gsub(/\./, separator) + unit_separator + unit.to_s.upcase
      end
      module_function :to_bytes
    end # Converter
  end # ProgressBar
end # TTY
