# frozen_string_literal: true

require_relative "../lib/tty-progressbar"

bar = TTY::ProgressBar.new("[:bar]", total: 10)

10.times do |i|
  bar.log("[#{i}] Task")
  sleep(0.1)
  bar.advance
end
