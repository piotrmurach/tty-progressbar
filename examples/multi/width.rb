require_relative '../../lib/tty-progressbar'

bars = TTY::ProgressBar::Multi.new("main [:bar] :percent")

bar1 = bars.register "foo [:bar] :percent", total: 150
bar2 = bars.register "bar [:bar] :percent", total: 250
bar3 = bars.register "baz [:bar] :percent", total: 100

th1 = Thread.new { 150.times { sleep(0.1); bar1.advance } }
th2 = Thread.new { 250.times { sleep(0.1); bar2.advance } }
th3 = Thread.new { 100.times { sleep(0.1); bar3.advance } }

[th1, th2, th3].each(&:join)
