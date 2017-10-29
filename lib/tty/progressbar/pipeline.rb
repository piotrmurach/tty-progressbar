module TTY
  class ProgressBar
    # Used by {ProgressBar} to decorate format string
    #
    # @api private
    class Pipeline
      include Enumerable

      # Create formatting pipeline
      #
      # @api private
      def initialize(formatters = [])
        @formatters = formatters
        freeze
      end

      # Add a new formatter
      #
      # @example
      #   use(TTY::ProgressBar::TotalFormatter)
      #
      # @api public
      def use(formatter)
        formatters << proc { |progress| formatter.new(progress) }
      end

      # Decorate the tokenized string with actual values
      #
      # @return [nil]
      #
      # @api private
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
