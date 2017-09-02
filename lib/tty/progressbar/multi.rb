# encoding: utf-8
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
        @bars = []
        @rows = 0
        @top_bar = nil
        @top_bar = register(format) if format
      end

      # Register a new progress bar
      #
      # @param [String] format
      #   the formatting string to display the bar
      #
      # @api public
      def register(format, options = {})
        bar = TTY::ProgressBar.new(format, @options.merge(options))

        synchronize do
          bar.attach_to(self)
          @bars << bar

          if @top_bar
            @top_bar.update(total: total, width: total)
            observe(bar)
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
      # @api public
      def observe(bar)
        bar.on(:progress) { top_bar.current = current }
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
        (@bars - [@top_bar]).dup.map(&:total).reduce(&:+)
      end

      # Calculate total current progress of all bars
      #
      # @return [Integer]
      #
      # @api public
      def current
        (@bars - [@top_bar]).dup.map(&:current).reduce(&:+)
      end

      # Check if all progress bars are complete
      #
      # @return [Boolean]
      #
      # @api public
      def complete?
        (@bars - [@top_bar]).dup.all?(&:complete?)
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
    end # Multi
  end # ProgressBar
end # TTY
