RSpec.describe TTY::ProgressBar, 'events' do
  let(:output) { StringIO.new('', 'w+') }

  it "emits :progress event when advancing" do
    events = []
    bar = TTY::ProgressBar.new("[:bar]", output: output, total: 5)
    bar.on(:progress) { events << :progress }

    bar.advance

    expect(events).to eq([:progress])
  end

  it "emits :done event when finished" do
    events = []
    bar = TTY::ProgressBar.new("[:bar]", output: output, total: 5)
    bar.on(:done) { events << :done }

    bar.finish

    expect(events).to eq([:done])
  end

  it "emits :stopped event" do
    events = []
    bar = TTY::ProgressBar.new("[:bar]", output: output, total: 5)
    bar.on(:stopped) { events << :stopped }

    bar.stop

    expect(events).to eq([:stopped])
  end
end
