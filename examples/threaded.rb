# frozen_string_literal: true

require_relative "../lib/tty-progressbar"

threads = []

bar = TTY::ProgressBar.new("[:bar] :percent", total: 30)

threads << Thread.new do
  15.times { sleep(0.1); bar.update(complete: "-", head: "-"); bar.advance; }
end
threads << Thread.new do
  15.times { sleep(0.1); bar.update(complete: "+", head: "+"); bar.advance; }
end

threads.map(&:join)
