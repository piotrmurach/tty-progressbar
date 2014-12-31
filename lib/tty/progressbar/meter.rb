# coding: utf-8

module TTY
  class ProgressBar
    # Used by {ProgressBar} to measure progress rate per interval
    # by default 1s
    #
    # @api privatek
    class Meter
      # Create Meter
      #
      # @param [Integer] interval
      #   the interval for measurement samples
      #
      # @api private
      def initialize(interval)
        @samples  = Hash.new { |h, el| h[el] = [] }
        @interval = interval || 1 # 1 sec
        @marker   = 0

        @start_time     = Time.now.to_f
        @last_sample_at = @start_time
      end

      def start
        @start_time     = Time.now.to_f
        @last_sample_at = @start_time
      end

      # Update meter with value
      #
      # @api public
      def sample(at, value)
        if @interval < at.to_f - @last_sample_at
          @marker += 1
        end
        @samples[@marker] << value

        @last_sample_at = at.to_f
      end

      # The rate of sampling
      #
      # @api public
      def rate
        samples = @samples[@marker]
        result = samples.inject(:+).to_f / samples.size
        result.nan? ? 0 : result
      end

      # Group all rates per interval
      #
      # @api public
      def rates
        @samples.reduce([]) do |acc, (key, _)|
          acc << @samples[key].reduce(:+)
        end
      end

      # The mean rate
      #
      # @api public
      def mean_rate
        if rates.size == 1
          rate
        else
          rates.reduce(:+).to_f / rates.size
        end
      end
      alias_method :avg_rate, :mean_rate

      # Reset the meter by clearing out it's metrics
      #
      # @api public
      def clear
        @marker = 0
        @samples.clear
      end
    end # Meter
  end # ProgressBar
end # TTY
