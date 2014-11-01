# coding: utf-8

module TTY
  class ProgressBar
    class ElapsedFormatter
      def initialize(progress, *args, &block)
        @progress = progress
        @converter = TTY::ProgressBar::Converter.new
      end

      def format(value)
        elapsed = (Time.now - @progress.start_at)
        value.gsub(/:elapsed/, @converter.to_time(elapsed))
      end
    end # ElapsedFormatter
  end # ProgressBar
end # TTY
