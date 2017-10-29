# frozen_string_literal: true

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
        @interval = interval || 1 # 1 sec
        start
      end

      # Start sampling timer
      #
      # @api public
      def start
        @start_time = Time.now
        @current    = 0
        @samples    = [[@start_time, 0]]
        @rates      = []
        @start_time
      end

      # Update meter with value
      #
      # @param [Time] at
      #   the time of the sampling
      #
      # @param [Integer] value
      #   the current value of progress
      #
      # @api public
      def sample(at, value)
        @current += value
        prune_samples(at)
        @samples << [at, @current]
        save_rate(at)
      end

      # Remove samples that are obsolete
      #
      # @api private
      def prune_samples(at)
        cutoff = at - @interval
        while @samples.size > 1 && (@samples.first.first < cutoff)
          @samples.shift
        end
      end

      # If we crossed a period boundary since @start_time,
      # save the rate for {#rates}
      #
      # @api private
      def save_rate(at)
        period_index = ((at - @start_time) / @interval).floor
        while period_index > @rates.size
          @rates << rate
        end
      end

      # The current rate of sampling for a given interval
      #
      # @return [Number]
      #   the current rate in decimal or 0 if cannot be determined
      #
      # @api public
      def rate
        first_at, first_value = @samples.first
        last_at,  last_value  = @samples.last
        if first_at == last_at
          0
        else
          (last_value - first_value) / (last_at - first_at)
        end
      end

      # Group all rates per interval
      #
      # @api public
      def rates
        @rates + [rate]
      end

      # The mean rate of all the sampled rates
      #
      # @return [Number]
      #   the mean rate
      #
      # @api public
      def mean_rate
        last_at, last_value = @samples.last
        if last_at == @start_time
          0
        else
          last_value / (last_at - @start_time)
        end
      end
      alias_method :avg_rate, :mean_rate

      # Reset the meter by clearing out it's metrics
      #
      # @api public
      def clear
        start
      end
    end # Meter
  end # ProgressBar
end # TTY
