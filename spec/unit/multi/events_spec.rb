RSpec.describe TTY::ProgressBar::Multi, 'events' do
  let(:output) { StringIO.new('', 'w+') }

  it "emits :progress event when any of the registerd bars advances" do
    events = []
    bars = TTY::ProgressBar::Multi.new("[:bar]", output: output, total: 5)
    bars.on(:progress) { events << :progress }

    bar = bars.register "one [:bar]"
    bar.advance

    expect(events).to eq([:progress])
  end

  it "emits :done event when all progress bars finished under top level" do
    events = []
    bars = TTY::ProgressBar::Multi.new("[:bar]", output: output, total: 5)
    bars.on(:done) { events << :done }
    bar = bars.register "one [:bar]"

    bar.finish

    expect(events).to eq([:done])
    expect(bar.complete?).to eq(true)
  end

  it "emits :done event when all progress bars finished without top level" do
    events = []
    bars = TTY::ProgressBar::Multi.new(output: output)
    bars.on(:done) { events << :done }
    bar = bars.register "one [:bar]", total: 5

    bar.finish

    expect(events).to eq([:done])
    expect(bars.complete?).to eq(true)
  end

  it "emits :done event when top level registered bar finished" do
    events = []
    bars = TTY::ProgressBar::Multi.new("[:bar]", output: output, total: 5)
    bars.on(:done) { events << :done }

    bar = bars.register "one [:bar]", total: 5

    bars.finish

    expect(events).to eq([:done])
    expect(bar.complete?).to eq(true)
  end

  it "emits :done event when top level bar finished" do
    events = []
    bars = TTY::ProgressBar::Multi.new(output: output)
    bars.on(:done) { events << :done }

    bar = bars.register "one [:bar]", total: 5

    bars.finish

    expect(events).to eq([:done])
    expect(bar.complete?).to eq(true)
  end

  it "emits :stopped event when all registerd bars are stopped under top level" do
    events = []
    bars = TTY::ProgressBar::Multi.new("[:bar]", output: output, total: 5)
    bars.on(:stopped) { events << :stopped }

    bar = bars.register "one [:bar]"

    bar.stop

    expect(events).to eq([:stopped])
    expect(bars.stopped?).to eq(true)
  end

  it "emits :stopped event when all registerd bars are stopped without top level" do
    events = []
    bars = TTY::ProgressBar::Multi.new(output: output)
    bars.on(:stopped) { events << :stopped }

    bar = bars.register "one [:bar]", total: 5

    bar.stop

    expect(events).to eq([:stopped])
    expect(bars.stopped?).to eq(true)
  end

  it "emits :stopped event when registerd multi bar finished" do
    events = []
    bars = TTY::ProgressBar::Multi.new("[:bar]", output: output, total: 5)
    bars.on(:stopped) { events << :stopped }

    bars.register "one [:bar]"

    bars.stop

    expect(events).to eq([:stopped])
  end

  it "emits :stopped event when multi bar finished" do
    events = []
    bars = TTY::ProgressBar::Multi.new(output: output)
    bars.on(:stopped) { events << :stopped }

    bars.register "one [:bar]", total: 5

    bars.stop

    expect(events).to eq([:stopped])
    expect(bars.stopped?).to eq(true)
  end
end
