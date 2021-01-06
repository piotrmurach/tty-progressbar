# frozen_string_literal: true

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
      #   use(TTY::ProgressBar::TotalFormatter.new(progress_bar))
      #
      # @api public
      def use(formatter)
        formatters << formatter
      end

      # Decorate the tokenized string with actual values
      #
      # @example
      #   decorate("[:bar] :current :elapsed")
      #
      # @param [String] tokenized
      #   the string with tokens
      #
      # @return [nil]
      #
      # @api private
      def decorate(tokenized)
        base = tokenized.dup
        formatters.inject(base) do |formatted, formatter|
          if formatter.respond_to?(:matches?) && formatter.matches?(formatted)
            formatter.(formatted)
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
