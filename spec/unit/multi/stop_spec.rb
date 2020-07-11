RSpec.describe TTY::ProgressBar::Multi, "#stop" do
  let(:output) { StringIO.new("", "w+") }

  it "stops all bars when top level stops" do
    bars = TTY::ProgressBar::Multi.new("main [:bar]", output: output)

    bar1 = bars.register("[:bar]", total: 5)
    bar2 = bars.register("[:bar]", total: 10)

    bars.stop

    expect(bar1.stopped?).to eq(true)
    expect(bar2.stopped?).to eq(true)
    expect(bars.stopped?).to eq(true)
  end

  it "doesn't stop top bar when child stops" do
    bars = TTY::ProgressBar::Multi.new("main [:bar]", output: output)

    bar1 = bars.register("[:bar]", total: 5)
    bar2 = bars.register("[:bar]", total: 10)

    bar1.stop

    expect(bars.stopped?).to eq(false)
    expect(bar1.stopped?).to eq(true)
    expect(bar2.stopped?).to eq(false)
  end
end
