RSpec.describe TTY::ProgressBar::Multi, '#line_inset' do
  let(:output) { StringIO.new('', 'w+') }

  it "doesn't create inset when no top level bar" do
    bars = TTY::ProgressBar::Multi.new(output: output)

    bar = bars.register 'example'

    expect(bars.line_inset(bar)).to eq('')
  end

  it "defaults to the empty string for the top level bar" do
    bars = TTY::ProgressBar::Multi.new("Top level spinner", output: output)

    expect(bars.line_inset(bars.top_bar))
      .to eq(TTY::ProgressBar::Multi::DEFAULT_INSET[:top])
  end

  it "returns middle character for a top level bar" do
    bars = TTY::ProgressBar::Multi.new("Top level bar", output: output)

    bar = bars.register 'middle', total: 10
    bar2 = bars.register 'bottom', total: 10

    bar.start
    bar2.start

    expect(bars.line_inset(bar))
      .to eq(TTY::ProgressBar::Multi::DEFAULT_INSET[:middle])
  end

  it "decorates last bar" do
    bars = TTY::ProgressBar::Multi.new("Top spinner", output: output)

    bar1 = bars.register 'middle', total: 10
    bar = bars.register 'bottom', total: 10

    bar1.start
    bar.start

    expect(bars.line_inset(bar))
      .to eq(TTY::ProgressBar::Multi::DEFAULT_INSET[:bottom])
  end

  it "allows customization" do
    opts = {
        output: output,
        style: {
          top: ". ",
          middle: "--",
          bottom: "---",
        }
      }
    bars = TTY::ProgressBar::Multi.new("Top level spinner", opts)
    middle_bar = bars.register "", total: 10
    bottom_bar = bars.register "", total: 10

    middle_bar.start
    bottom_bar.start

    expect(bars.line_inset(bars.top_bar)).to eq(". ")
    expect(bars.line_inset(middle_bar)).to eq("--")
    expect(bars.line_inset(bottom_bar)).to eq("---")
  end
end
