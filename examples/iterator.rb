# encoding: utf-8

require 'tty-progressbar'

bar = TTY::ProgressBar.new("[:bar]")

bar.iterate(30.times) { sleep(0.1) }
