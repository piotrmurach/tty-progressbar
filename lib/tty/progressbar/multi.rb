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
    end # Multi
  end # ProgressBar
end # TTY
