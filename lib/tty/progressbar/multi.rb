# frozen_string_literal: true

require 'forwardable'
require 'monitor'

require_relative '../progressbar'

module TTY
  class ProgressBar
    # Used for managing multiple terminal progress bars
    #
    # @api public
    class Multi
      include Enumerable
      include MonitorMixin

      extend Forwardable

      def_delegators :@bars, :each, :empty?, :length, :[]

      def_delegators :@top_bar, :width, :width=

      DEFAULT_INSET = {
        top:    Gem.win_platform? ? '+ '   : "\u250c ",
        middle: Gem.win_platform? ? '|-- ' : "\u251c\u2500\u2500 ",
        bottom: Gem.win_platform? ? '|__ ' : "\u2514\u2500\u2500 "
      }.freeze

      # Number of currently occupied rows in terminal display
      attr_reader :rows

      # Create a multibar
      #
      # @example
      #   bars = TTY::ProgressBar::Multi.new
      #
      # @example
      #   bars = TTY::ProgressBar::Multi.new("main [:bar]")
      #
      # @param [String] format
      #   the formatting string to display this bar
      #
      # @param [Hash] options
      #
      # @api public
      def initialize(*args)
        super()
        @options = args.last.is_a?(::Hash) ? args.pop : {}
        format = args.empty? ? nil : args.pop
        @inset_opts = @options.delete(:style) { DEFAULT_INSET }
        @bars = []
        @rows = 0
        @top_bar = nil
        @top_bar = register(format, observable: false) if format

        @width = @options[:width]
        @top_bar.update(width: @width) if @width

        @callbacks = {
          progress: [],
          stopped:  [],
          done:     []
        }
      end

      # Register a new progress bar
      #
      # @param [String] format
      #   the formatting string to display the bar
      #
      # @api public
      def register(format, options = {})
        observable = options.delete(:observable) { true }
        bar = TTY::ProgressBar.new(format, @options.merge(options))

        synchronize do
          bar.attach_to(self)
          @bars << bar
          observe(bar) if observable
          if @top_bar
            @top_bar.update(total: total)
            @top_bar.update(width: total) unless @width
          end
        end

        bar
      end

      # Increase row count
      #
      # @api public
      def next_row
        synchronize do
          @rows += 1
        end
      end

      # Observe a bar for emitted events
      #
      # @param [TTY::ProgressBar] bar
      #   the bar to observe for events
      #
      # @api private
      def observe(bar)
        bar.on(:progress, &progress_handler)
           .on(:done) { emit(:done) if complete? }
           .on(:stopped)  { emit(:stopped) if stopped? }
      end

      # Handle the progress event
      #
      # @api private
      def progress_handler
        -> (progress) do
          @top_bar.advance(progress) if @top_bar
          emit(:progress, progress)
        end
      end

      # Get the top level bar if it exists
      #
      # @api public
      def top_bar
        raise "No top level progress bar" unless @top_bar

        @top_bar
      end

      def start
        raise "No top level progress bar" unless @top_bar

        @top_bar.start
      end

      # Calculate total maximum progress of all bars
      #
      # @return [Integer]
      #
      # @api public
      def total
        synchronize do
          (@bars - [@top_bar]).dup.map(&:total).reduce(&:+)
        end
      end

      # Calculate total current progress of all bars
      #
      # @return [Integer]
      #
      # @api public
      def current
        synchronize do
          (@bars - [@top_bar]).dup.map(&:current).reduce(&:+)
        end
      end

      # Check if all progress bars are complete
      #
      # @return [Boolean]
      #
      # @api public
      def complete?
        synchronize do
          (@bars - [@top_bar]).dup.all?(&:complete?)
        end
      end

      # Check if any of the registered progress bars is stopped
      #
      # @return [Boolean]
      #
      # @api public
      def stopped?
        synchronize do
          (@bars - [@top_bar]).dup.any?(&:stopped?)
        end
      end

      # Stop all progress bars
      #
      # @api public
      def stop
        @bars.dup.each(&:stop)
      end

      # Finish all progress bars
      #
      # @api public
      def finish
        @bars.dup.each(&:finish)
      end

      # Find the number of characters to move into the line
      # before printing the bar
      #
      # @param [TTY::ProgressBar] bar
      #   the progress bar for which line inset is calculated
      #
      # @return [String]
      #   the inset
      #
      # @api public
      def line_inset(bar)
        return '' if @top_bar.nil?

        case bar.row
        when @top_bar.row
          @inset_opts[:top]
        when rows
          @inset_opts[:bottom]
        else
          @inset_opts[:middle]
        end
      end

      # Listen on event
      #
      # @param [Symbol] name
      #   the event name to listen on
      #
      # @api public
      def on(name, &callback)
        unless @callbacks.key?(name)
          raise ArgumentError, "The event #{name} does not exist. "\
                               " Use :progress, :stopped, or :done instead"
        end
        @callbacks[name] << callback
        self
      end

      private

      # Fire an event by name
      #
      # @api private
      def emit(name, *args)
        @callbacks[name].each do |callback|
          callback.(*args)
        end
      end
    end # Multi
  end # ProgressBar
end # TTY
