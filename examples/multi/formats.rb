# frozen_string_literal: true

require_relative "../../lib/tty-progressbar"

bars = []
multi_bar = TTY::ProgressBar::Multi.new(width: 50)

TTY::ProgressBar::Formats::FORMATS.each_key do |format|
  bars << multi_bar.register("%8s |:bar|" % [format],
                             total: 50, bar_format: format)
end

50.times do
  bars.each do |bar|
    sleep(0.01)
    bar.advance
  end
end
