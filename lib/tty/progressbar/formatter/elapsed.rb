# frozen_string_literal: true

require_relative '../converter'

module TTY
  class ProgressBar
    # Used by {Pipeline} to format :elapsed token
    #
    # @api private
    class ElapsedFormatter
      MATCHER = /:elapsed/.freeze

      def initialize(progress)
        @progress  = progress
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
        elapsed = (Time.now - @progress.start_at)
        value.gsub(MATCHER, Converter.to_time(elapsed))
      end
    end # ElapsedFormatter
  end # ProgressBar
end # TTY
