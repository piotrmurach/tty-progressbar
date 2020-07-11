# frozen_string_literal: true

require_relative "../../lib/tty-progressbar"

bars = TTY::ProgressBar::Multi.new("main [:bar] (:current/:total)")

bar1 = bars.register "foo [:bar] :percent", total: 10
10.times { bar1.advance; sleep(0.1) }

bar2 = bars.register "bar [:bar] :percent", total: 15
15.times { bar2.advance; sleep(0.1) }
