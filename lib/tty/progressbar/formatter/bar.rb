# frozen_string_literal: true

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
        without_bar = value.gsub(/:bar/, '')
        available_space = [0, ProgressBar.max_columns -
                              ProgressBar.display_columns(without_bar) -
                              @progress.inset].max
        width = [@progress.width, available_space].min
        complete_bar_length    = (width * @progress.ratio).round
        complete_char_length   = ProgressBar.display_columns(@progress.complete)
        incomplete_char_length = ProgressBar.display_columns(@progress.incomplete)

        # decimal number of items only when unicode chars are used
        # otherwise it has no effect on regular ascii chars
        complete_items   = (complete_bar_length / complete_char_length.to_f).round
        incomplete_items = (width - complete_items * complete_char_length) / incomplete_char_length

        complete   = Array.new(complete_items, @progress.complete)
        incomplete = Array.new(incomplete_items, @progress.incomplete)
        complete[-1] = @progress.head if complete_bar_length > 0

        bar = ''
        bar += complete.join
        bar += incomplete.join

        value.gsub(MATCHER, bar)
      end
    end # BarFormatter
  end #  ProgressBar
end # TTY
