# frozen_string_literal: true

require_relative "../lib/tty-progressbar"

bar = TTY::ProgressBar.new("downloading [:bar] :current/:total :current_byte " \
                           ":total_byte :percent ET::elapsed ETA::eta " \
                           ":rate/s :mean_rate/s :byte_rate/s :mean_byte/s",
                           width: 40)

170.times do |i|
  sleep(0.05)
  bar.advance
  if i == 69
    bar.update(total: 170)
  end
end
