# frozen_string_literal: true

require_relative "../lib/tty-progressbar"

bar = TTY::ProgressBar.new("Unicode [:bar]", total: nil,
                           head: ">", complete: "本", incomplete: "〜",
                           unknown: "<本>", width: 31)

60.times { sleep(0.05); bar.advance }

bar.update(total: 100)

40.times { sleep(0.1); bar.advance }
