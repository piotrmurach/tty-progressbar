# coding: utf-8

module TTY
  class ProgressBar
    class ByteFormatter
      # Used by {Pipeline} to format :byte token
      #
      # @api private
      def initialize(progress)
        @progress = progress
        @converter = Converter.new
      end

      def format(value)
        bytes = @converter.to_bytes(@progress.current)
        value.gsub(/:byte/, bytes)
      end
    end # ByteFormatter
  end # ProgressBar
end # TTY
