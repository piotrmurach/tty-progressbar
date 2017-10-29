RSpec.describe TTY::ProgressBar::Multi, '#register' do
  let(:output) { StringIO.new('', 'w+') }

  it "registers a TTY::ProgressBar instance" do
    bars = TTY::ProgressBar::Multi.new(output: output)
    allow_any_instance_of(TTY::ProgressBar).to receive(:attach_to)
    expect_any_instance_of(TTY::ProgressBar).to receive(:attach_to)

    bar = bars.register("[:bar]")

    expect(bar).to be_instance_of(TTY::ProgressBar)
    expect(bars.length).to eq(1)
  end

  it "uses global options to register instance" do
    bars = TTY::ProgressBar::Multi.new(output: output, total: 100)
    bar = double(:bar, attach_to: nil)
    allow(bar).to receive(:on).and_return(bar)
    allow(TTY::ProgressBar).to receive(:new).and_return(bar)

    bars.register("[:bar]")

    expect(TTY::ProgressBar).to have_received(:new).with("[:bar]", {total: 100, output: output})
  end

  it "registers bars with top level" do
    bars = TTY::ProgressBar::Multi.new("main [:bar]", output: output)

    bars.register("[:bar]", total: 5)
    bars.register("[:bar]", total: 10)

    expect(bars.total).to eq(15)
    expect(bars.current).to eq(0)
  end
end
