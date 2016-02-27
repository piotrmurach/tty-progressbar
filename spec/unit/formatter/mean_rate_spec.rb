# encoding: utf-8

RSpec.describe TTY::ProgressBar, ':mean_rate token' do
  let(:output) { StringIO.new('', 'w+') }

  before { Timecop.safe_mode = false }

  it "shows current rate per sec" do
    time_now = Time.local(2014, 10, 5, 12, 0, 0)
    Timecop.freeze(time_now)
    progress = TTY::ProgressBar.new(":mean_rate", output: output, total: 100, interval: 1)
    5.times do |i|
      time_now = Time.local(2014, 10, 5, 12, 0, i * 2)
      Timecop.freeze(time_now)
      progress.advance(i * 10)
    end
    output.rewind
    expect(output.read).to eq([
      "\e[1G 0.00",
      "\e[1G 5.00",
      "\e[1G10.00",
      "\e[1G15.00",
      "\e[1G20.00\n"
    ].join)
    Timecop.return
  end
end
