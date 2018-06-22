require_relative '../../lib/tty-progressbar'

bars = TTY::ProgressBar::Multi.new("main [:bar] :percent")

bar1 = bars.register "foo [:bar] :percent", total: 150
bar2 = bars.register "bar [:bar] :percent", total: 250
bar3 = bars.register "baz [:bar] :percent", total: 100

th1 = Thread.new { 15.times { sleep(0.1); bar1.advance(10) } }
th2 = Thread.new { 50.times { sleep(0.1); bar2.advance(5)} }
th3 = Thread.new { 50.times { sleep(0.1); bar3.advance(5) } }

[th1, th2, th3].each(&:join)
