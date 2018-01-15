require_relative '../lib/tty-progressbar'

bar = TTY::ProgressBar.new("[:bar]", total: 30)

bar.iterate(30.times) { sleep(0.1) }
