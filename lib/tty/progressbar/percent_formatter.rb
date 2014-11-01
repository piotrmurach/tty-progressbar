# coding: utf-8

module TTY
  class ProgressBar
    class PercentFormatter
      def initialize(progress, *args, &block)
        @progress = progress
      end

      def format(value)
        percent = @progress.width == 0 ? 100 : (@progress.ratio * 100).to_i
        value.gsub(/:percent/, percent.to_s + '%')
      end
    end # PercentFormatter
  end # ProgressBar
end # TTY
