require_relative '../lib/tty-progressbar'

bar = TTY::ProgressBar.new("downloading [:bar] :percent", head: '>', total: 30)
30.times do |i|
  if i == 15
    bar.update(head: 'x')
    bar.stop
    break
  end
  sleep(0.1)
  bar.advance
end
