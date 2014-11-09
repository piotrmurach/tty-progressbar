# coding: utf-8

require 'io/console'
require 'forwardable'

require 'tty/progressbar/converter'
require 'tty/progressbar/version'
require 'tty/progressbar/pipeline'
require 'tty/progressbar/bar_formatter'
require 'tty/progressbar/current_formatter'
require 'tty/progressbar/elapsed_formatter'
require 'tty/progressbar/estimated_formatter'
require 'tty/progressbar/percent_formatter'
require 'tty/progressbar/total_formatter'

module TTY
  # Used for creating terminal progress bar
  #
  # @api public
  class ProgressBar
    extend Forwardable

    ECMA_ESC = "\x1b"
    ECMA_CSI = "\x1b["
    ECMA_CHA = 'G'

    DEC_RST = 'l'
    DEC_SET = 'h'
    DEC_TCEM = '?25'

    attr_reader :format

    attr_reader :total

    attr_reader :width

    attr_reader :no_width

    attr_reader :current

    attr_reader :start_at

    attr_reader :complete

    attr_reader :incomplete

    attr_reader :hide_cursor

    attr_reader :output

    def_delegator :@pipeline, :use

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
    #
    # @api public
    def initialize(format, options = {})
      @format      = format
      @total       = options.fetch(:total) { fail ArgumentError }
      @width       = options.fetch(:width) { @total }
      @no_width    = options.fetch(:no_width) { false }
      @clear       = options.fetch(:clear) { false }
      @incomplete  = options.fetch(:incomplete) { ' ' }
      @complete    = options.fetch(:complete) { '=' }
      @hide_cursor = options.fetch(:hide_cursor) { false }
      @output      = options.fetch(:output) { $stderr }
      @frequency   = options.fetch(:frequency) { 0 } # 0Hz

      @width             = 0 if @no_width
      @render_period     = @frequency == 0 ? 0 : 1.0 / @frequency
      @current           = 0
      @readings          = 0
      @last_render_time  = Time.now
      @last_render_width = 0
      @done              = false
      @start_at          = Time.now
      @pipeline          = TTY::ProgressBar::Pipeline.new

      default_pipeline
      register_callbacks
    end

    # Advance the progress bar
    #
    # @param [Object|Number] progress
    #
    # @api public
    def advance(progress = 1)
      return if @done

      @start_at = Time.now if @current.zero?
      @readings += 1
      @current  += progress

      if !no_width && @current >= total
        finish && return
      end

      now = Time.now
      return if (now - @last_render_time) < @render_period
      render
    end

    # Ratio of completed over total steps
    #
    # @return [Float]
    #
    # @api public
    def ratio
      proportion = (@current.to_f / @total)
      [[proportion, 0].max, 1].min
    end

    # Determine terminal width
    #
    # @api public
    def max_columns
      IO.console.winsize.last
    end

    # Render progress to the output
    #
    # @api private
    def render
      return if @done
      if @hide_cursor && @last_render_width == 0 && !(@current >= total)
        write(ECMA_CSI + DEC_TCEM + DEC_RST)
      end

      formatted = @pipeline.decorate(self, @format)
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
      @output.print(ECMA_CSI + '1' + ECMA_CHA) if clear_first
      @output.print(data)
      @output.flush
    end

    # Resize progress bar with new configuration
    #
    # @api public
    def resize(new_width)
      fail 'Cannot resize finished progress bar' if @done

      if new_width
        @no_width = false
        @width    = new_width
      else
        @no_width = true
        @width    = 0
      end

      advance(0) # rerender with new configuration
    end

    # End the progress
    #
    # @api public
    def finish
      # reenable cursor if it is turned off
      if @hide_cursor && @last_render_width != 0
        write(ECMA_CSI + DEC_TCEM + DEC_SET, false)
      end
      return if @done
      @current = @width if @no_width
      render
      write("\n", false)
      @done = true
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

    # Prepare default pipeline formatters
    #
    # @api private
    def default_pipeline
      @pipeline.use TTY::ProgressBar::CurrentFormatter
      @pipeline.use TTY::ProgressBar::TotalFormatter
      @pipeline.use TTY::ProgressBar::ElapsedFormatter
      @pipeline.use TTY::ProgressBar::EstimatedFormatter
      @pipeline.use TTY::ProgressBar::PercentFormatter
      @pipeline.use TTY::ProgressBar::BarFormatter
    end

    # Handle resize and kill signals
    #
    # @api private
    def register_callbacks
      callback = proc { send(:resize, max_columns) }
      Signal.trap('SIGWINCH', &callback)

      Signal.trap('KILL') { @terminate }
    end
  end # ProgressBar
end # TTY
