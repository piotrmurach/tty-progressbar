# encoding: utf-8

RSpec.describe TTY::ProgressBar::Multi, '#finish' do
  let(:output) { StringIO.new('', 'w+') }

  it "finishes all bars" do
    bars = TTY::ProgressBar::Multi.new("main [:bar]", output: output)

    bar1 = bars.register("[:bar]", total: 5)
    bar2 = bars.register("[:bar]", total: 10)

    expect(bars.complete?).to eq(false)

    bar1.finish
    bar2.finish

    expect(bars.complete?).to eq(true)
  end
end
