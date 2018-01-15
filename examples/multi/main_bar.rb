require_relative '../../lib/tty-progressbar'

bars = TTY::ProgressBar::Multi.new("main [:bar] :percent")

bar1 = bars.register "foo [:bar] :percent", total: 15
bar2 = bars.register "bar [:bar] :percent", total: 15
bar3 = bars.register "baz [:bar] :percent", total: 45

th1 = Thread.new { 15.times { sleep(0.1); bar1.advance } }
th2 = Thread.new { 15.times { sleep(0.1); bar2.advance } }
th3 = Thread.new { 45.times { sleep(0.1); bar3.advance } }

[th1, th2, th3].each(&:join)
