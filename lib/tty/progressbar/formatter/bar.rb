# coding: utf-8

module TTY
  class ProgressBar
    # Used by {Pipeline} to format bar
    #
    # @api private
    class BarFormatter
      MATCHER = /:bar/.freeze

      def initialize(progress)
        @progress = progress
      end

      # Determines whether this formatter is applied or not.
      #
      # @param [Object] value
      #
      # @return [Boolean]
      #
      # @api private
      def matches?(value)
        !!(value.to_s =~ MATCHER)
      end

      # Format :bar token
      #
      # @param [String] value
      #  the value being formatted
      #
      # @api public
      def format(value)
        available_space = [0, @progress.max_columns - value.gsub(/:bar/, '').length].max
        width = [@progress.width, available_space].min
        complete_length = (width * @progress.ratio).round
        complete   = Array.new(complete_length, @progress.complete)
        incomplete = Array.new(width - complete_length, @progress.incomplete)

        bar = ''
        bar += complete.join
        bar += incomplete.join

        value.gsub(MATCHER, bar)
      end
    end # BarFormatter
  end #  ProgressBar
end # TTY
