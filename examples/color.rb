require 'pastel'

require_relative '../lib/tty-progressbar'

pastel = Pastel.new
green = pastel.on_green(" ")
red = pastel.on_red(" ")

bar = TTY::ProgressBar.new("|:bar|",
  total: 30,
  complete: green,
  incomplete: red
)

30.times do
  sleep(0.1)
  bar.advance
end
