# frozen_string_literal: true

require_relative "../lib/tty-progressbar"

format = "[:bar] :percent :elapsed :mean_rate/s ETA :eta :eta_time"
bar = TTY::ProgressBar.new(format, total: 10)

10.times do |i|
  bar.log("[#{i}] Task")
  sleep(0.2)
  bar.advance
end
