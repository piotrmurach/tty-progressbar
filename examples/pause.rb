# frozen_string_literal: true

require_relative "../lib/tty-progressbar"

bar = TTY::ProgressBar.new("[:bar] :current/:total :current_byte/:total_byte " \
                           ":rate/s :mean_rate/s ET::elapsed ETA::eta", total: 40)

20.times { sleep(0.1); bar.advance }

bar.pause
sleep(1)
bar.resume

20.times { sleep(0.1); bar.advance }
