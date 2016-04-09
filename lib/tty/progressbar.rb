# coding: utf-8

module TTY
  # Used for creating terminal progress bar
  #
  # @api public
  class ProgressBar
    extend Forwardable

    ECMA_ESC = "\e".freeze
    ECMA_CSI = "\e[".freeze
    ECMA_CHA = 'G'.freeze
    ECMA_CLR = 'K'.freeze

    DEC_RST  = 'l'.freeze
    DEC_SET  = 'h'.freeze
    DEC_TCEM = '?25'.freeze

    attr_reader :format

    attr_reader :current

    attr_reader :start_at

    def_delegators :@configuration, :total, :width, :no_width,
                   :complete, :incomplete, :hide_cursor, :clear,
                   :output, :frequency, :interval, :width=

    def_delegators :@meter, :rate, :mean_rate

    def_delegator :@formatter, :use

    # Create progress bar
    #
    # @param [String] format
    #   the tokenized string that displays the output
    #
    # @param [Hash] options
    # @option options [Numeric] :total
    #   the total number of steps to completion
    # @option options [Numeric] :width
    #   the maximum width for the bars display including
    #   all formatting options
    # @option options [Boolean] :no_width
    #   true when progression is unknown defaulting to false
    # @option options [Boolean] :clear
    #   whether or not to clear the progress line
    # @option options [Boolean] :hide_cursor
    #   display or hide cursor
    # @option options [Object] :output
    #   the object that responds to print call defaulting to stderr
    # @option options [Number] :frequency
    #   the frequency with which to display bars
    # @option options [Number] :interval
    #   the period for sampling of speed measurement
    #
    # @api public
    def initialize(format, options = {})
      @format        = format
      @configuration = Configuration.new(options)
      yield @configuration if block_given?

      @width             = 0 if no_width
      @render_period     = frequency == 0 ? 0 : 1.0 / frequency
      @current           = 0
      @readings          = 0
      @last_render_time  = Time.now
      @last_render_width = 0
      @done              = false
      @start_at          = Time.now
      @started           = false
      @tokens            = {}
      @formatter         = TTY::ProgressBar::Formatter.new
      @meter             = Meter.new(options.fetch(:interval, 1))

      @formatter.load
    end

    # Start progression by drawing bar and setting time
    #
    # @api public
    def start
      @started  = true
      @start_at = Time.now
      @meter.start

      advance(0)
    end

    # Advance the progress bar
    #
    # @param [Object|Number] progress
    #
    # @api public
    def advance(progress = 1, tokens = {})
      #handle_signals
      return if @done

      if progress.respond_to?(:to_hash)
        tokens, progress = progress, 1
      end
      @start_at  = Time.now if @current.zero? && !@started
      @readings += 1
      @current  += progress
      @tokens    = tokens
      @meter.sample(Time.now, progress)

      if !no_width && @current >= total
        finish && return
      end

      now = Time.now
      return if (now - @last_render_time) < @render_period
      render
    end

    # Advance the progress bar to the updated value
    #
    # @param [Number] value
    #   the desired value to updated to
    #
    # @api public
    def current=(value)
      value = [0, [value, total].min].max
      advance(value - @current)
    end

    # Advance the progress bar to an exact ratio.
    # The target value is set to the closest available value.
    #
    # @param [Float] value
    #   the ratio between 0 and 1 inclusive
    #
    # @api public
    def ratio=(value)
      target = (value * total).floor
      advance(target - @current)
    end

    # Ratio of completed over total steps
    #
    # @return [Float]
    #
    # @api public
    def ratio
      proportion = total > 0 ? (@current.to_f / total) : 0
      [[proportion, 0].max, 1].min
    end

    # Render progress to the output
    #
    # @api private
    def render
      return if @done
      if hide_cursor && @last_render_width == 0 && !(@current >= total)
        write(ECMA_CSI + DEC_TCEM + DEC_RST)
      end

      formatted = @formatter.decorate(self, @format)
      @tokens.each do |token, val|
        formatted = formatted.gsub(":#{token}", val)
      end
      write(formatted, true)

      @last_render_time  = Time.now
      @last_render_width = formatted.length
    end

    # Write out to the output
    #
    # @param [String] data
    #
    # @api private
    def write(data, clear_first = false)
      output.print(ECMA_CSI + '1' + ECMA_CHA) if clear_first
      output.print(data)
      output.flush
    end

    # Resize progress bar with new configuration
    #
    # @param [Integer] new_width
    #   the new width for the bar display
    #
    # @api public
    def resize(new_width = nil)
      return if @done
      clear_line
      if new_width
        self.width = new_width
      end
    end

    # End the progress
    #
    # @api public
    def finish
      # reenable cursor if it is turned off
      if hide_cursor && @last_render_width != 0
        write(ECMA_CSI + DEC_TCEM + DEC_SET, false)
      end
      return if @done
      @current = total unless no_width
      render
      clear ? clear_line : write("\n", false)
      @meter.clear
      @done = true
    end

    # Clear current line
    #
    # @api public
    def clear_line
      output.print(ECMA_CSI + '0m' + ECMA_CSI + '1000D' + ECMA_CSI + ECMA_CLR)
    end

    # Reset progress to default configuration
    #
    # @api public
    def reset
      @current  = 0
      @readings = 0
      @done     = false
      @meter.clear

      advance(0) # rerender with new configuration
    end

    # Check if progress is finised
    #
    # @return [Boolean]
    #   true when progress finished, false otherwise
    #
    # @api public
    def complete?
      @done
    end

    # Log message above the current progress bar
    #
    # @param [String] message
    #   the message to log out
    #
    # @api public
    def log(message)
      sanitized_message = message.gsub(/\r|\n/, ' ')
      if @done
        write(sanitized_message + "\n", false)
        return
      end
      sanitized_message = padout(sanitized_message)

      write(sanitized_message + "\n", true)
      render
    end

    # Determine terminal width
    #
    # @return [Integer]
    #
    # @api public
    def max_columns
      TTY::Screen.width
    end

    # Show bar format
    #
    # @return [String]
    #
    # @api public
    def to_s
      @format.to_s
    end

    # Inspect bar properties
    #
    # @return [String]
    #
    # @api public
    def inspect
      output = "#<#{self.class.name} "
      output << "@format=\"#{format}\", "
      output << "@current=\"#{@current}\", "
      output << "@total=\"#{total}\", "
      output << "@width=\"#{width}\", "
      output << "@complete=\"#{complete}\", "
      output << "@incomplete=\"#{incomplete}\", "
      output << "@interval=\"#{interval}\">"
    end

    private

    # Pad message out with spaces
    #
    # @api private
    def padout(message)
      if @last_render_width > message.length
        remaining_width = @last_render_width - message.length
        message += ' ' * remaining_width
      end
      message
    end
  end # ProgressBar
end # TTY
