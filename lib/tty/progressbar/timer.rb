# frozen_string_literal: true

module TTY
  class ProgressBar
    # Used to measure the elapsed time for multiple time intervals
    #
    # @api private
    class Timer
      attr_reader :start_time

      # Create Timer
      #
      # @api private
      def initialize
        reset
      end

      # Reset the start time to nil and elapsed time to zero
      #
      # @api public
      def reset
        @running = false
        @offset = 0
        @start_time = nil
      end

      # Check whether or not the timer is running
      #
      # @return [Boolean]
      #
      # @api public
      def running?
        @running
      end

      # Total elapsed time
      #
      # @return [Float]
      #   the elapsed time in seconds
      #
      # @api public
      def elapsed_time
        if running?
          elapsed_until_now + @offset
        else
          @offset
        end
      end

      # Measure current time interval
      #
      # @api public
      def elapsed_until_now
        time_so_far = Time.now - @start_time
        # protect against negative time drifting
        time_so_far > 0 ? time_so_far : 0
      end

      # Start measuring elapsed time for a new interval
      #
      # @return [Time]
      #   return the start time
      #
      # @api public
      def start
        return @start_time if running?

        @running = true
        @start_time = Time.now
      end

      # Stop measuring elapsed time for the current interval
      #
      # @return [Float]
      #   return elapsed time for the stopped interval
      #
      # @api public
      def stop
        return 0 unless running?

        interval = elapsed_until_now
        @offset += interval
        @running = false
        @start_time = nil
        interval
      end
    end # Timer
  end # ProgressBar
end # TTY
