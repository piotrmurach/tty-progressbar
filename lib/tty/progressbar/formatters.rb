# frozen_string_literal: true

require "forwardable"

require_relative "pipeline"

require_relative "formatter/bar"
require_relative "formatter/current"
require_relative "formatter/current_byte"
require_relative "formatter/elapsed"
require_relative "formatter/estimated"
require_relative "formatter/estimated_time"
require_relative "formatter/percent"
require_relative "formatter/rate"
require_relative "formatter/byte_rate"
require_relative "formatter/mean_rate"
require_relative "formatter/mean_byte"
require_relative "formatter/total"
require_relative "formatter/total_byte"

module TTY
  class ProgressBar
    class Formatters
      extend Forwardable

      def_delegators :@pipeline, :decorate, :use

      # @api private
      def initialize(pipeline = nil)
        @pipeline = pipeline || TTY::ProgressBar::Pipeline.new
      end

      # Prepare default pipeline formatters
      #
      # @api private
      def load(progress)
        @pipeline.use TTY::ProgressBar::CurrentFormatter.new(progress)
        @pipeline.use TTY::ProgressBar::TotalFormatter.new(progress)
        @pipeline.use TTY::ProgressBar::TotalByteFormatter.new(progress)
        @pipeline.use TTY::ProgressBar::ElapsedFormatter.new(progress)
        @pipeline.use TTY::ProgressBar::EstimatedTimeFormatter.new(progress)
        @pipeline.use TTY::ProgressBar::EstimatedFormatter.new(progress)
        @pipeline.use TTY::ProgressBar::PercentFormatter.new(progress)
        @pipeline.use TTY::ProgressBar::ByteFormatter.new(progress)
        @pipeline.use TTY::ProgressBar::ByteRateFormatter.new(progress)
        @pipeline.use TTY::ProgressBar::RateFormatter.new(progress)
        @pipeline.use TTY::ProgressBar::MeanRateFormatter.new(progress)
        @pipeline.use TTY::ProgressBar::MeanByteFormatter.new(progress)
        @pipeline.use TTY::ProgressBar::BarFormatter.new(progress)
      end
    end # Formatters
  end # ProgressBar
end # TTY
