require_relative '../lib/tty-progressbar'

bar = TTY::ProgressBar.new("Unicode [:bar]", total: 30, complete: 'あ')
30.times do
  sleep(0.1)
  bar.advance
end
