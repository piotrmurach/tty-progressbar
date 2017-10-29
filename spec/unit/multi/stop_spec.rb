RSpec.describe TTY::ProgressBar::Multi, '#stop' do
  let(:output) { StringIO.new('', 'w+') }

  it "stops all bars when top level stops" do
    bars = TTY::ProgressBar::Multi.new("main [:bar]", output: output)

    bar1 = bars.register("[:bar]", total: 5)
    bar2 = bars.register("[:bar]", total: 10)

    bars.stop

    expect(bar1.stopped?).to eq(true)
    expect(bar2.stopped?).to eq(true)
  end
end
