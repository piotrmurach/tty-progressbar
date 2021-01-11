# frozen_string_literal: true

RSpec.describe TTY::ProgressBar, "#pause" do
  let(:output) { StringIO.new }

  it "pauses progress without printing newline" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 10)
    5.times { |i|
      progress.pause if i == 3
      progress.advance
    }
    expect(progress.complete?).to be(false)
    expect(progress.paused?).to be(true)

    output.rewind
    expect(output.read).to eq([
      "\e[1G[=         ]",
      "\e[1G[==        ]",
      "\e[1G[===       ]",
    ].join)
  end
end
