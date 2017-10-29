RSpec.describe TTY::ProgressBar, 'frequency' do
  let(:output) { StringIO.new('', 'w+') }

  before { Timecop.safe_mode = false }

  it "limits frequency to 500Hz, permiting every second one" do
    time_now = Time.local(2014, 10, 5, 12, 0, 0, 0)
    Timecop.freeze(time_now)
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 10, frequency: 500)

    10.times do |sec|
      time_now = Time.local(2014, 10, 5, 12, 0, 0, sec * 1000)
      Timecop.freeze(time_now)
      progress.advance
    end

    output.rewind
    expect(output.read).to eq([
      "\e[1G[===       ]",
      "\e[1G[=====     ]",
      "\e[1G[=======   ]",
      "\e[1G[========= ]",
      "\e[1G[==========]\n"
    ].join)
    Timecop.return
  end
end
