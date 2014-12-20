# coding: utf-8

module TTY
  class ProgressBar
    # Used by {Pipeline} to format bar
    #
    # @api private
    class BarFormatter
      def initialize(progress, *args, &block)
        @progress = progress
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

        value.gsub(/:bar/, bar)
      end
    end # BarFormatter
  end #  ProgressBar
end # TTY
