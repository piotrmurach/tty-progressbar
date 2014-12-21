# coding: utf-8

module TTY
  class ProgressBar
    class ByteFormatter
      MATCHER = /:byte/.freeze
      # Used by {Pipeline} to format :byte token
      #
      # @api private
      def initialize(progress)
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
        bytes = @converter.to_bytes(@progress.current)
        value.gsub(MATCHER, bytes)
      end
    end # ByteFormatter
  end # ProgressBar
end # TTY
