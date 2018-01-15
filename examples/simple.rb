require_relative '../lib/tty-progressbar'

bar = TTY::ProgressBar.new("downloading [:bar] :elapsed :percent", total: 30)
30.times do
  sleep(0.1)
  bar.advance
end
