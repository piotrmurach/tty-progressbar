require_relative '../lib/tty-progressbar'

threads = []

bar = TTY::ProgressBar.new("[:bar] :percent", total: 30)

threads << Thread.new {
  15.times { sleep(0.1); bar.update(complete: '-', head: '-'); bar.advance(); }
}
threads << Thread.new {
  15.times { sleep(0.1); bar.update(complete: '+', head: '+'); bar.advance(); }
}

threads.map(&:join)
