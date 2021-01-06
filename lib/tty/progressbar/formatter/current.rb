# frozen_string_literal: true

module TTY
  class ProgressBar
    # Used by {Pipeline} to format :current token
    #
    # @api private
    class CurrentFormatter
      include TTY::ProgressBar::Formatter[/:current\b/i.freeze]

      # Format :current token
      #
      # @param [String] value
      #  the value to format
      #
      # @api public
      def call(value)
        value.gsub(matcher, @progress.current.to_s)
      end
    end # CurrentFormatter
  end # ProgressBar
end # TTY
