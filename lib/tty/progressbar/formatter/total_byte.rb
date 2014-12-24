# coding: utf-8

module TTY
  class ProgressBar
    class TotalByteFormatter
      MATCHER = /:total_byte/.freeze

      # Used by {Pipeline} to format :total_byte token
      #
      # @api private
      def initialize(progress, *args, &block)
        @progress = progress
        @converter = Converter.new
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

      def format(value)
        bytes = @converter.to_bytes(@progress.total)
        value.gsub(MATCHER, bytes)
      end
    end # TotalByteFormatter
  end # ProgressBar
end # TTY
