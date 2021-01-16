# frozen_string_literal: true

require_relative "../../lib/tty-progressbar"

bars = []
multi_bar = TTY::ProgressBar::Multi.new(width: 50)

TTY::ProgressBar::Formats::FORMATS.each_key do |format|
  bars << multi_bar.register("%10s |:bar|" % [format], hide_cursor: true,
                             total: 50, bar_format: format)
end

begin
  50.times do
    bars.each do |bar|
      sleep(0.002)
      bar.advance
    end
  end
ensure
  multi_bar.stop
end
