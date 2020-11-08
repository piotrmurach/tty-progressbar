# frozen_string_literal: true

require_relative "formats"

module TTY
  class ProgressBar
    class Configuration
      include TTY::ProgressBar::Formats

      attr_reader :total

      attr_accessor :width

      attr_accessor :incomplete

      attr_accessor :complete

      attr_accessor :unknown

      attr_accessor :head

      attr_accessor :clear_head

      attr_accessor :hide_cursor

      attr_accessor :clear

      attr_accessor :output

      attr_accessor :frequency

      attr_accessor :interval

      attr_accessor :inset

      attr_accessor :bar_format

      def initialize(options)
        self.total   = options[:total] if options[:total]
        @width       = options.fetch(:width) { total }
        @bar_format  = options.fetch(:bar_format) { :classic }
        @incomplete  = options.fetch(:incomplete) { fetch_char(@bar_format, :incomplete) }
        @complete    = options.fetch(:complete) { fetch_char(@bar_format, :complete) }
        @unknown     = options.fetch(:unknown) { fetch_char(@bar_format, :unknown) }
        @head        = options.fetch(:head) { @complete || "=" }
        @clear_head  = options.fetch(:clear_head) { false }
        @hide_cursor = options.fetch(:hide_cursor) { false }
        @clear       = options.fetch(:clear) { false }
        @output      = options.fetch(:output) { $stderr }
        @frequency   = options.fetch(:frequency) { 0 } # 0Hz
        @interval    = options.fetch(:interval) { 1 } # 1 sec
        @inset       = options.fetch(:inset) { 0 }
      end

      def total=(value)
        raise ArgumentError unless value

        @total = value
        self.width = value if width.nil?
      end

      private

      # Find bar char by type name and property
      #
      # @param [Symbol] name
      # @param [Symbol] property
      #
      # @api private
      def fetch_char(name, property)
        if FORMATS.key?(name)
          FORMATS[name][property]
        else
          raise ArgumentError, "unsupported bar format: #{name.inspect}. " \
                               "Available formats are: " \
                               "#{FORMATS.keys.sort.map(&:inspect).join(', ')}"
        end
      end
    end # Configuration
  end # ProgressBar
end # TTY
