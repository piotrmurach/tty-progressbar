# encoding: utf-8

RSpec.describe TTY::ProgressBar, 'events' do
  let(:output) { StringIO.new('', 'w+') }

  it "emits :done event" do
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
