# frozen_string_literal: true

RSpec.describe TTY::ProgressBar::Multi, "#pause" do
  let(:output) { StringIO.new }

  it "pauses all bars when top level pauses" do
    bars = TTY::ProgressBar::Multi.new("main [:bar]", output: output)

    bar1 = bars.register("[:bar]", total: 5)
    bar2 = bars.register("[:bar]", total: 10)

    bars.pause

    expect(bar1.paused?).to eq(true)
    expect(bar2.paused?).to eq(true)
    expect(bars.paused?).to eq(true)
  end

  it "doesn't pause top bar when child pauses" do
    bars = TTY::ProgressBar::Multi.new("main [:bar]", output: output)

    bar1 = bars.register("[:bar]", total: 5)
    bar2 = bars.register("[:bar]", total: 10)

    bar1.pause

    expect(bars.paused?).to eq(false)
    expect(bar1.paused?).to eq(true)
    expect(bar2.paused?).to eq(false)
  end
end
