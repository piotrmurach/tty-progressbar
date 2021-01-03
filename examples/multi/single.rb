# frozen_string_literal: true

require_relative "../../lib/tty-progressbar"

bars = TTY::ProgressBar::Multi.new("main [:bar] :percent")

foo_bar = bars.register "foo [:bar] :percent", total: 30
bar_bar = bars.register "bar [:bar] :percent", total: 30
baz_bar = bars.register "baz [:bar] :percent", total: 30

30.times do |i|
  foo_bar.advance
  bar_bar.advance(2) if i.even?
  baz_bar.advance(3) if (i % 3).zero?
  sleep(0.1)
end
