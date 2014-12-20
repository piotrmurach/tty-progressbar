# coding: utf-8

module TTY
  class ProgressBar
    class TotalFormatter
      def initialize(progress, *args, &block)
        @progress = progress
      end

      def format(value)
        value.gsub(/:total/, @progress.total.to_s)
      end
    end # TotalFormatter
  end # ProgressBar
end # TTY
