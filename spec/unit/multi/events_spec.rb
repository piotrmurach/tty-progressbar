# encoding: utf-8

RSpec.describe TTY::ProgressBar::Multi, 'events' do
  let(:output) { StringIO.new('', 'w+') }

  it "emits :progress eent when any of the registerd bars advances" do
    events = []
    bars = TTY::ProgressBar::Multi.new("[:bar]", output: output, total: 5)
    bars.on(:progress) { events << :progress }

    bar = bars.register "one [:bar]"
    bar.advance

    expect(events).to eq([:progress])
  end

  it "emits :done event when all progress bars finished" do
    events = []
    bars = TTY::ProgressBar::Multi.new("[:bar]", output: output, total: 5)
    bars.on(:done) { events << :done }

    bar = bars.register "one [:bar]"

    bar.finish

    expect(events).to eq([:done])
  end

  it "emits :done event when top level bar finished" do
    events = []
    bars = TTY::ProgressBar::Multi.new("[:bar]", output: output, total: 5)
    bars.on(:done) { events << :done }

    bars.register "one [:bar]"

    bars.finish

    expect(events).to eq([:done])
  end

  it "emits :stopped event when all registerd bars are stopped" do
    events = []
    bars = TTY::ProgressBar::Multi.new("[:bar]", output: output, total: 5)
    bars.on(:stopped) { events << :stopped }

    bar = bars.register "one [:bar]"

    bar.stop

    expect(events).to eq([:stopped])
  end

  it "emits :stopped event when top level bar finished" do
    events = []
    bars = TTY::ProgressBar::Multi.new("[:bar]", output: output, total: 5)
    bars.on(:stopped) { events << :stopped }

    bars.register "one [:bar]"

    bars.stop

    expect(events).to eq([:stopped])
  end
end
