# coding: utf-8

module TTY
  class ProgressBar
    # Used by {ProgressBar} to decorate format string
    #
    # @api private
    class Pipeline
      include Enumerable

      def initialize(formatters = [])
        @formatters = formatters
      end

      # Add new formatter
      #
      # @ api public
      def use(formatter, *args, &block)
        formatters << proc { |progress| formatter.new(progress, *args, &block) }
      end

      def decorate(progress, tokenized)
        base = tokenized.dup
        formatters.inject(base) do |formatted, formatter|
          instance = formatter.call(progress)
          if instance.respond_to?(:matches?) && instance.matches?(formatted)
            instance.format(formatted)
          else
            formatted
          end
        end
      end

      # Iterate over formatters
      #
      # @api public
      def each(&block)
        formatters.each(&block)
      end

      protected

      attr_reader :formatters
    end # Pipeline
  end # ProgressBar
end # TTY
