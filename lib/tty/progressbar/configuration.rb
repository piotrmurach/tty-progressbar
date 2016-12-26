# coding: utf-8

module TTY
  class ProgressBar
    class Configuration

      attr_reader :total

      attr_accessor :width

      attr_accessor :no_width

      attr_accessor :incomplete

      attr_accessor :complete

      attr_accessor :hide_cursor

      attr_accessor :clear

      attr_accessor :output

      attr_accessor :frequency

      attr_accessor :interval

      def initialize(options)
        self.total   = options[:total] if options[:total]
        @width       = options.fetch(:width) { total }
        @no_width    = options.fetch(:no_width) { false }
        @incomplete  = options.fetch(:incomplete) { ' ' }
        @complete    = options.fetch(:complete) { '=' }
        @hide_cursor = options.fetch(:hide_cursor) { false }
        @clear       = options.fetch(:clear) { false }
        @output      = options.fetch(:output) { $stderr }
        @frequency   = options.fetch(:frequency) { 0 } # 0Hz
      end

      def total=(value)
        fail ArgumentError unless value
        @total = value
        @width = value unless width
      end
    end # Configuration
  end # ProgressBar
end # TTY
