# encoding: utf-8

RSpec.describe TTY::ProgressBar, ':byte_rate token' do
  let(:output) { StringIO.new('', 'w+') }

  before { Timecop.safe_mode = false }

  it "shows current rate in bytes per sec" do
    time_now = Time.local(2014, 10, 5, 12, 0, 0)
    Timecop.freeze(time_now)
    progress = TTY::ProgressBar.new(":byte_rate", output: output, total: 10000, interval: 1)
    5.times do |i|
      time_now = Time.local(2014, 10, 5, 12, 0, i * 2)
      Timecop.freeze(time_now)
      progress.advance(i * 1000)
    end
    output.rewind
    expect(output.read).to eq([
      "\e[1G0.0B",
      "\e[1G1000.0B",
      "\e[1G1.95KB",
      "\e[1G2.93KB",
      "\e[1G3.91KB\n"
    ].join)
    Timecop.return
  end
end
