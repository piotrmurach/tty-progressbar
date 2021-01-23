# frozen_string_literal: true

RSpec.describe TTY::ProgressBar, "#start" do
  let(:output) { StringIO.new }

  it "starts timer and draws initial progress" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 10)

    progress.start
    progress.advance

    output.rewind
    expect(output.read).to eq([
      "\e[1G[          ]",
      "\e[1G[=         ]"
    ].join)
  end

  it "starts timer and displays time and rate metrics" do
    Timecop.freeze(Time.local(2021, 1, 23, 12, 0, 0))
    format = "[:bar] :percent :elapsed :eta :eta_time :rate/s"
    progress = TTY::ProgressBar.new(format, output: output, total: 10)

    Timecop.freeze(Time.local(2021, 1, 23, 12, 0, 1)) do
      progress.start
    end

    3.times do |sec|
      Timecop.freeze(Time.local(2021, 1, 23, 12, 0, 3 + sec)) do
        progress.advance
      end
    end

    output.rewind
    expect(output.read).to eq([
      "\e[1G[          ] 0%  0s --s --:--:--  0.00/s",
      "\e[1G[=         ] 10%  2s 18s 12:00:21 0.50000/s",
      "\e[1G[==        ] 20%  3s 12s 12:00:16  1.00/s  ",
      "\e[1G[===       ] 30%  4s  9s 12:00:14  1.00/s",
    ].join)
  end
end
