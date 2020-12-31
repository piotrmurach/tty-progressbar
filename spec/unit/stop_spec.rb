# frozen_string_literal: true

RSpec.describe TTY::ProgressBar, "#stop" do
  let(:output) { StringIO.new }

  it "stops progress and prints newline" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 10)
    5.times { |i|
      progress.stop if i == 3
      progress.advance
    }
    expect(progress.complete?).to be(false)
    output.rewind
    expect(output.read).to eq([
      "\e[1G[=         ]",
      "\e[1G[==        ]",
      "\e[1G[===       ]",
      "\e[1G[===       ]\n"
    ].join)
  end

  it "stops progress and clears the display" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 10,
                                              clear: true)
    2.times { progress.advance }
    progress.stop

    expect(progress.complete?).to be(false)
    output.rewind
    expect(output.read).to eq([
      "\e[1G[=         ]",
      "\e[1G[==        ]",
      "\e[1G[==        ]",
      "\e[0m\e[2K\e[1G"
    ].join)
  end

  it "stops progress and restores hidden cursor" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 10,
                                              hide_cursor: true)
    2.times { progress.advance }
    progress.stop

    expect(progress.complete?).to be(false)
    output.rewind
    expect(output.read).to eq([
      "\e[?25l",
      "\e[1G[=         ]",
      "\e[1G[==        ]",
      "\e[?25h\e[1G[==        ]\n"
    ].join)
  end
end
