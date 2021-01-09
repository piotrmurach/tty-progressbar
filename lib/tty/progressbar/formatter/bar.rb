# frozen_string_literal: true

require_relative "../formatter"

module TTY
  class ProgressBar
    # Used by {Pipeline} to format bar
    #
    # @api private
    class BarFormatter
      include TTY::ProgressBar::Formatter[/:bar/i.freeze]

      # Format :bar token
      #
      # @param [String] value
      #  the value being formatted
      #
      # @api public
      def call(value)
        without_bar = value.gsub(/:bar/, "")
        available_space = [0, ProgressBar.max_columns -
                              ProgressBar.display_columns(without_bar) -
                              @progress.inset].max
        width = [@progress.width.to_i, available_space].min

        # When we don't know the total progress, use either user
        # defined width or rely on terminal width detection
        if @progress.indeterminate?
          width = available_space if width.zero?

          format_indeterminate(value, width)
        else
          format_determinate(value, width)
        end
      end

      private

      # @api private
      def format_indeterminate(value, width)
        buffer = []
        possible_width = width
        unknown_char_length    = ProgressBar.display_columns(@progress.unknown)
        complete_char_length   = ProgressBar.display_columns(@progress.complete)
        incomplete_char_length = ProgressBar.display_columns(@progress.incomplete)
        head_char_length       = ProgressBar.display_columns(@progress.head)

        possible_width -= unknown_char_length
        max_char_length = [complete_char_length, incomplete_char_length,
                           head_char_length].max
        # figure out how many unicode chars would fit normally
        # when the bar has total to prevent resizing
        possible_width = (possible_width / max_char_length) * max_char_length
        complete = (possible_width * @progress.ratio).round
        incomplete = possible_width - complete

        buffer << " " * complete
        buffer << @progress.unknown
        buffer << " " * incomplete

        value.gsub(matcher, buffer.join)
      end

      # @api private
      def format_determinate(value, width)
        complete_bar_length    = (width * @progress.ratio).round
        complete_char_length   = ProgressBar.display_columns(@progress.complete)
        incomplete_char_length = ProgressBar.display_columns(@progress.incomplete)
        head_char_length       = ProgressBar.display_columns(@progress.head)

        # division by char length only when unicode chars are used
        # otherwise it has no effect on regular ascii chars
        complete_items = [
          complete_bar_length / complete_char_length,
          # or see how many incomplete (unicode) items fit
          (complete_bar_length / incomplete_char_length) * incomplete_char_length
        ].min

        complete_width = complete_items * complete_char_length
        incomplete_width = width - complete_width
        incomplete_items = [
          incomplete_width / incomplete_char_length,
          # or see how many complete (unicode) items fit
          (incomplete_width / complete_char_length) * complete_char_length
        ].min

        complete   = Array.new(complete_items, @progress.complete)
        incomplete = Array.new(incomplete_items, @progress.incomplete)

        if complete_items > 0 && head_char_length > 0 &&
           (incomplete_items > 0 || incomplete_items.zero? && !@progress.clear_head)
          # see how many head chars per complete char
          times = (head_char_length / complete_char_length.to_f).round
          if complete_items < times # not enough complete chars to fit
            incomplete.pop(times - complete_items)
          end
          complete.pop(times)
          extra_space = " " * (times * complete_char_length - head_char_length)
          complete << "#{@progress.head}#{extra_space}"
        end

        value.gsub(matcher, "#{complete.join}#{incomplete.join}")
      end
    end # BarFormatter
  end #  ProgressBar
end # TTY
