# frozen_string_literal: true

module TTY
  class ProgressBar
    class Configuration

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

      def initialize(options)
        self.total   = options[:total] if options[:total]
        @width       = options.fetch(:width) { total }
        @incomplete  = options.fetch(:incomplete) { " " }
        @complete    = options.fetch(:complete) { "=" }
        @unknown     = options.fetch(:unknown) { "<=>" }
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
        fail ArgumentError unless value
        @total = value
        self.width = value if width.nil?
      end
    end # Configuration
  end # ProgressBar
end # TTY
