# frozen_string_literal: true

require_relative "../../lib/tty-progressbar"

threads = []
bars = TTY::ProgressBar::Multi.new(width: 50)

TTY::ProgressBar::Formats::FORMATS.each_key do |format|
  bar = bars.register("%8s |:bar|" % [format], total: 50, bar_format: format)
  threads << Thread.new { 50.times { sleep(0.05); bar.advance } }
end

threads.each(&:join)
