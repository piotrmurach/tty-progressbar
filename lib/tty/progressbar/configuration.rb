# frozen_string_literal: true

require_relative "formats"

module TTY
  class ProgressBar
    class Configuration
      include TTY::ProgressBar::Formats

      attr_reader :total

      attr_accessor :width

      attr_reader :incomplete

      attr_reader :complete

      attr_reader :unknown

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
        @bar_format  = options.fetch(:bar_format, :classic)
        self.incomplete = options.fetch(:incomplete) { fetch_char(@bar_format, :incomplete) }
        self.complete = options.fetch(:complete) { fetch_char(@bar_format, :complete) }
        self.unknown = options.fetch(:unknown) { fetch_char(@bar_format, :unknown) }
        @head        = options.fetch(:head) { @complete || "=" }
        @clear_head  = options.fetch(:clear_head, false)
        @hide_cursor = options.fetch(:hide_cursor, false)
        @clear       = options.fetch(:clear, false)
        @output      = options.fetch(:output) { $stderr }
        @frequency   = options.fetch(:frequency, 0) # 0Hz
        @interval    = options.fetch(:interval, 1) # 1 sec
        @inset       = options.fetch(:inset, 0)
      end

      # Set complete character(s)
      #
      # @param [String] value
      #
      # @api public
      def complete=(value)
        raise_if_empty(:complete, value)

        @complete = value
      end

      # Set incomplete character(s)
      #
      # @param [String] value
      #
      # @api public
      def incomplete=(value)
        raise_if_empty(:incomplete, value)

        @incomplete = value
      end

      # Set unknown character(s)
      #
      # @param [String] value
      #
      # @api public
      def unknown=(value)
        raise_if_empty(:unknown, value)

        @unknown = value
      end

      # Set total and adjust width if unset
      #
      # @param [Integer,nil] value
      #
      # @api public
      def total=(value)
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

      # Check whether a parameter's value is empty or not
      #
      # @raise [ArgumentError]
      #
      # @api private
      def raise_if_empty(name, value)
        return value unless value.to_s.empty?

        raise ArgumentError, "cannot provide an empty string for #{name.inspect}"
      end
    end # Configuration
  end # ProgressBar
end # TTY
