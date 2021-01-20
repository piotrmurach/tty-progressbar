# frozen_string_literal: true

require "io/console"
require "forwardable"
require "monitor"
require "tty-cursor"
require "tty-screen"
require "strings-ansi"
require "unicode/display_width"

require_relative "progressbar/timer"
require_relative "progressbar/configuration"
require_relative "progressbar/formatters"
require_relative "progressbar/meter"
require_relative "progressbar/version"

module TTY
  # Used for creating terminal progress bar
  #
  # @api public
  class ProgressBar
    extend Forwardable
    include MonitorMixin

    ECMA_CSI = "\e["

    NEWLINE = "\n"

    CURSOR_LOCK = Monitor.new

    attr_accessor :format

    attr_reader :current

    attr_reader :row

    def_delegators :@configuration, :total, :width, :complete, :incomplete,
                   :head, :clear_head, :hide_cursor, :clear, :output,
                   :frequency, :interval, :inset, :width=, :unknown, :bar_format

    def_delegators :@meter, :rate, :mean_rate

    def_delegators :@timer, :elapsed_time, :start_time

    # Determine terminal width
    #
    # @return [Integer]
    #
    # @api public
    def self.max_columns
      TTY::Screen.width
    end

    # Determine the monospace display width of a string
    #
    # @param [String] value
    #   the value to determine width of
    #
    # @return [Integer]
    #
    # @api public
    def self.display_columns(value)
      Unicode::DisplayWidth.of(Strings::ANSI.sanitize(value))
    end

    # Create progress bar
    #
    # @example
    #   bar = TTY::Progressbar.new
    #   bar.configure do |config|
    #     config.total = 20
    #   end
    #
    # @param [String] format
    #   the tokenized string that displays the output
    #
    # @param [Hash] options
    # @option options [Numeric] :total
    #   the total number of steps to completion
    # @option options [Numeric] :width
    #   the maximum width for the progress bar except all formatting tokens
    # @option option [String] :complete
    #   the complete character in progress animation
    # @option options [String] :incomplete
    #   the incomplete character in progress animation
    # @option options [String] :head
    #   the head character, defaults to complete
    # @option options [String] :unknown
    #   the unknown character for indeterminate progress animation
    # @option options [Boolean] :bar_format
    #   the preconfigured bar format name, defaults to :classic
    # @option options [Object] :output
    #   the object that responds to print call, defaults to stderr
    # @option options [Number] :frequency
    #   the frequency with which to display a progress bar per second
    # @option options [Number] :interval
    #   the time interval for sampling of speed measurement, defaults to 1 second
    # @option options [Boolean] :hide_cursor
    #   whether or not to hide the cursor, defaults to false
    # @option options [Boolean] :clear
    #   whether or not to clear the progress line, defaults to false
    # @option options [Boolean] :clear_head
    #   whether or not to replace head character with complete, defaults to false
    #
    # @api public
    def initialize(format, options = {})
      super()
      @format = format
      if format.is_a?(Hash)
        raise ArgumentError, "Expected bar formatting string, " \
                             "got `#{format}` instead."
      end
      @configuration = TTY::ProgressBar::Configuration.new(options)
      yield @configuration if block_given?

      @formatters = TTY::ProgressBar::Formatters.new
      @meter = TTY::ProgressBar::Meter.new(interval)
      @timer = TTY::ProgressBar::Timer.new
      @callbacks = Hash.new { |h, k| h[k] = [] }

      @formatters.load(self)
      reset

      @first_render = true
      @multibar = nil
      @row = nil
    end

    # Reset progress to default configuration
    #
    # @api public
    def reset
      @width             = 0 if indeterminate?
      @render_period     = frequency == 0 ? 0 : 1.0 / frequency
      @current           = 0
      @unknown           = 0
      @last_render_time  = Time.now
      @last_render_width = 0
      @done              = false
      @stopped           = false
      @paused            = false
      @tokens            = {}

      @meter.clear
      @timer.reset
    end

    # Access instance configuration
    #
    # @api public
    def configure
      yield @configuration
    end

    # Check if progress can be determined or not
    #
    # @return [Boolean]
    #
    # @api public
    def indeterminate?
      total.nil?
    end

    # Attach this bar to multi bar
    #
    # @param [TTY::ProgressBar::Multi] multibar
    #   the multibar under which this bar is registered
    #
    # @api private
    def attach_to(multibar)
      @multibar = multibar
    end

    # Use custom token formatter
    #
    # @param [Object] formatter_class
    #   the formatter class to add to formatting pipeline
    #
    # @api public
    def use(formatter_class)
      unless formatter_class.is_a?(Class)
        raise ArgumentError, "Formatter needs to be a class"
      end

      @formatters.use(formatter_class.new(self))
    end

    # Start progression by drawing bar and setting time
    #
    # @api public
    def start
      synchronize do
        @timer.start
        @meter.start
      end

      advance(0)
    end

    # Advance the progress bar
    #
    # @param [Object|Number] progress
    #
    # @api public
    def advance(progress = 1, tokens = {})
      return if done?

      synchronize do
        emit(:progress, progress)
        if progress.respond_to?(:to_hash)
          tokens, progress = progress, 1
        end
        @timer.start
        @current += progress
        # When progress is unknown increase by 2% up to max 200%, after
        # that reset back to 0%
        @unknown += 2 if indeterminate?
        @unknown = 0 if @unknown > 199
        @tokens = tokens
        @meter.sample(Time.now, progress)

        if !indeterminate? && @current >= total
          finish && return
        end

        return if (Time.now - @last_render_time) < @render_period

        render
      end
    end

    # Iterate over collection either yielding computation to block
    # or provided Enumerator. If the bar's `total` was not set,
    # it would be taken from `collection.count`, otherwise previously
    # set `total` would be used. This allows using the progressbar
    # with infinite, lazy, or slowly-calculated enumerators.
    #
    # @note
    #   If `total` is set, iteration will NOT stop after this number of
    #   iterations, only when provided Enumerable is finished. It may
    #   be convenient in "unsure number of iterations" situations
    #   (like downloading in chunks, when server may eventually send
    #   more chunks than predicted), but be careful to not pass infinite
    #   enumerators without previously doing `.take(some_finite_number)`
    #   on them.
    #
    # @example
    #   bar.iterate(30.times) { ... }
    #
    # @param [Enumerable] collection
    #   the collection to iterate over
    #
    # @param [Integer] progress
    #   the amount to move progress bar by
    #
    # @return [Enumerator]
    #
    # @api public
    def iterate(collection, progress = 1, &block)
      update(total: collection.count * progress) unless total
      progress_enum = Enumerator.new do |iter|
        collection.each do |elem|
          advance(progress)
          iter.yield(elem)
        end
      end
      block_given? ? progress_enum.each(&block) : progress_enum
    end

    # Update configuration options for this bar
    #
    # @param [Hash[Symbol]] options
    #   the configuration options to update
    #
    # @api public
    def update(options = {})
      synchronize do
        options.each do |name, val|
          if @configuration.respond_to?("#{name}=")
            @configuration.public_send("#{name}=", val)
          end
        end
      end
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
    # When the total is unknown the progress ratio oscillates
    # by going up from 0 to 1 and then down from 1 to 0 and
    # up again to infinity.
    #
    # @return [Float]
    #
    # @api public
    def ratio
      synchronize do
        proportion = if total
                       total > 0 ? (@current.to_f / total) : 0
                     else
                       (@unknown > 100 ? 200 - @unknown : @unknown).to_f / 100
                     end
        [[proportion, 0].max, 1].min
      end
    end

    # Render progress to the output
    #
    # @api private
    def render
      return if done?

      if hide_cursor && @last_render_width == 0 &&
         (indeterminate? || @current < total)
        write(TTY::Cursor.hide)
      end

      if @multibar
        characters_in = @multibar.line_inset(self)
        update(inset: self.class.display_columns(characters_in))
      end

      formatted = @formatters.decorate(@format)
      @tokens.each do |token, val|
        formatted = formatted.gsub(":#{token}", val)
      end

      padded = padout(formatted)

      write(padded, true)

      @last_render_time  = Time.now
      @last_render_width = self.class.display_columns(formatted)
    end

    # Move cursor to a row of the current bar if the bar is rendered
    # under a multibar. Otherwise, do not move and yield on current row.
    #
    # @api private
    def move_to_row
      if @multibar
        CURSOR_LOCK.synchronize do
          if @first_render
            @row = @multibar.next_row
            yield if block_given?
            output.print NEWLINE
            @first_render = false
          else
            lines_up = (@multibar.rows + 1) - @row
            output.print TTY::Cursor.save
            output.print TTY::Cursor.up(lines_up)
            yield if block_given?
            output.print TTY::Cursor.restore
          end
        end
      else
        yield if block_given?
      end
    end

    # Write out to the output
    #
    # @param [String] data
    #
    # @api private
    def write(data, clear_first = false)
      return unless tty? # write only to terminal

      move_to_row do
        output.print(TTY::Cursor.column(1)) if clear_first
        characters_in = @multibar.line_inset(self) if @multibar
        output.print("#{characters_in}#{data}")
        output.flush
      end
    end

    # Resize progress bar with new configuration
    #
    # @param [Integer] new_width
    #   the new width for the bar display
    #
    # @api public
    def resize(new_width = nil)
      return if done?

      synchronize do
        clear_line
        if new_width
          self.width = new_width
        end
      end
    end

    # End the progress
    #
    # @api public
    def finish
      return if done?

      @current = total unless indeterminate?
      render
      clear ? clear_line : write(NEWLINE, false)
    ensure
      @meter.clear
      @done = true
      @timer.stop

      # reenable cursor if it is turned off
      if hide_cursor && @last_render_width != 0
        write(TTY::Cursor.show, false)
      end

      emit(:done)
    end

    # Resume rendering when bar is done, stopped or paused
    #
    # @api public
    def resume
      synchronize do
        @done = false
        @stopped = false
        @paused = false
      end
    end

    # Stop and cancel the progress at the current position
    #
    # @api public
    def stop
      return if done?

      render
      clear ? clear_line : write(NEWLINE, false)
    ensure
      @meter.clear
      @stopped = true
      @timer.stop

      # reenable cursor if it is turned off
      if hide_cursor && @last_render_width != 0
        write(TTY::Cursor.show, false)
      end

      emit(:stopped)
    end

    # Pause the progress at the current position
    #
    # @api public
    def pause
      synchronize do
        @paused = true
        @timer.stop
        emit(:paused)
      end
    end

    # Clear current line
    #
    # @api public
    def clear_line
      output.print("#{ECMA_CSI}0m#{TTY::Cursor.clear_line}")
    end

    # Check if progress is finished
    #
    # @return [Boolean]
    #   true when progress finished, false otherwise
    #
    # @api public
    def complete?
      @done
    end

    # Check if progress is stopped
    #
    # @return [Boolean]
    #
    # @api public
    def stopped?
      @stopped
    end

    # Check if progress is paused
    #
    # @return [Boolean]
    #
    # @api public
    def paused?
      @paused
    end

    # Check if progress is finished, stopped or paused
    #
    # @return [Boolean]
    #
    # @api public
    def done?
      @done || @stopped || @paused
    end

    # Register callback with this bar
    #
    # @param [Symbol] name
    #   the name for the event to listen for, e.i. :complete
    #
    # @return [self]
    #
    # @api public
    def on(name, &callback)
      synchronize do
        @callbacks[name] << callback
      end
      self
    end

    # Log message above the current progress bar
    #
    # @param [String] message
    #   the message to log out
    #
    # @api public
    def log(message)
      sanitized_message = message.gsub(/\r|\n/, " ")
      if done?
        write("#{sanitized_message}#{NEWLINE}", false)
        return
      end
      sanitized_message = padout(sanitized_message)

      write("#{sanitized_message}#{NEWLINE}", true)
      render
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
      "#<#{self.class.name} " \
      "@format=\"#{@format}\", " \
      "@current=\"#{@current}\", " \
      "@total=\"#{total}\", " \
      "@width=\"#{width}\", " \
      "@complete=\"#{complete}\", " \
      "@head=\"#{head}\", " \
      "@incomplete=\"#{incomplete}\", " \
      "@unknown=\"#{unknown}\", " \
      "@interval=\"#{interval}\">"
    end

    private

    # Pad message out with spaces
    #
    # @api private
    def padout(message)
      message_length = self.class.display_columns(message)

      if @last_render_width > message_length
        remaining_width = @last_render_width - message_length
        message += " " * remaining_width
      end
      message
    end

    # Emit callback by name
    #
    # @param [Symbol]
    #   the event name
    #
    # @api private
    def emit(name, *args)
      @callbacks[name].each do |callback|
        callback.(*args)
      end
    end

    # Check if IO is attached to a terminal
    #
    # return [Boolean]
    #
    # @api public
    def tty?
      output.respond_to?(:tty?) && output.tty?
    end
  end # ProgressBar
end # TTY
