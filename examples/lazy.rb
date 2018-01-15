require_relative '../lib/tty-progressbar'

bar = TTY::ProgressBar.new("[:bar] :current", total: 10, width: 20)

range = 1..Float::INFINITY
bar.iterate(range.lazy) { sleep(0.1) }
