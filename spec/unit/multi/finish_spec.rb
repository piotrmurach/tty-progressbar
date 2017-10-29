RSpec.describe TTY::ProgressBar::Multi, '#finish' do
  let(:output) { StringIO.new('', 'w+') }

  it "finishes all bars with top level" do
    bars = TTY::ProgressBar::Multi.new("main [:bar]", output: output)

    bar1 = bars.register("[:bar]", total: 5)
    bar2 = bars.register("[:bar]", total: 10)

    expect(bars.complete?).to eq(false)

    bar1.finish
    bar2.finish

    expect(bars.complete?).to eq(true)
  end

  it "finishes all bars without top level" do
    bars = TTY::ProgressBar::Multi.new(output: output)

    bar1 = bars.register("[:bar]", total: 5)
    bar2 = bars.register("[:bar]", total: 10)

    bar1.finish
    bar2.finish

    expect(bars.complete?).to eq(true)
  end

  it "finishes top level" do
    bars = TTY::ProgressBar::Multi.new(output: output)

    bar1 = bars.register("[:bar]", total: 5)
    bar2 = bars.register("[:bar]", total: 10)

    bars.finish

    expect(bar1.complete?).to eq(true)
    expect(bar2.complete?).to eq(true)
  end
end
