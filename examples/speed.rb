require_relative '../lib/tty-progressbar'

bar = TTY::ProgressBar.new "downloading [:bar] :rate/s :mean_rate/s" do |conf|
  conf.total = 100
  conf.interval = 1
end

30.times do
  sleep(0.1)
  bar.advance(Random.rand(10))
end
