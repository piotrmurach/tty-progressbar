# frozen_string_literal: true

require_relative "../lib/tty-progressbar"

bar = TTY::ProgressBar.new("Unicode [:bar]", total: 30,
                           head: ">", complete: "本", incomplete: "〜")
30.times do
  sleep(0.1)
  bar.advance
end
