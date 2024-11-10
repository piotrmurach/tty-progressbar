# frozen_string_literal: true

RSpec.describe TTY::ProgressBar, "#current=" do
  let(:output) { StringIO.new }

  it "allows to go back" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 10)
    3.times { progress.advance }
    progress.current = 5
    expect(progress.current).to eq(5)
    output.rewind
    expect(output.read).to eq([
      "\e[1G[=         ]",
      "\e[1G[==        ]",
      "\e[1G[===       ]",
      "\e[1G[=====     ]"
    ].join)
    progress.current = 0
    expect(progress.current).to eq(0)
  end

  it "doesn't allow to go over total" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 10)
    progress.current = 12
    expect(progress.current).to eq(10)
    output.rewind
    expect(output.read).to eq("\e[1G[==========]\n")
  end

  it "doesn't allow to go below 0" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 10)
    progress.current = -1
    expect(progress.current).to eq(0)
  end

  it "doesn't allow nil" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 10)
    expect {
      progress.current = nil
    }.to raise_error(
      ArgumentError,
      "Expected a numeric value, got nil instead."
    )
    expect(progress.current).to eq(0)
  end

  it "cannot backtrack on finished" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 10)
    progress.current = 10
    expect(progress.current).to eq(10)
    progress.current = 5
    expect(progress.current).to eq(10)
    output.rewind
    expect(output.read).to eq("\e[1G[==========]\n")
  end

  it "allows setting progress when the total is unknown" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: nil)
    progress.current = 5
    expect(progress.current).to eq(5)
  end
end
