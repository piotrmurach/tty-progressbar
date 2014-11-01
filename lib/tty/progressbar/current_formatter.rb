# coding: utf-8

module TTY
  class ProgressBar
    class CurrentFormatter
      def initialize(progress, *args, &block)
        @progress = progress
      end

      # Format :current token
      #
      # @param [String] value
      #  the value being formatted
      #
      # @api public
      def format(value)
        value.gsub(/:current/, @progress.current.to_s)
      end
    end # CurrentFormatter
  end # ProgressBar
end # TTY
