# frozen_string_literal: true

RSpec.describe TTY::ProgressBar, "#log" do
  let(:output) { StringIO.new }

  it "logs message" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 10)
    2.times {
      progress.log "foo bar"
      progress.advance
    }
    output.rewind
    expect(output.read).to eq([
      "\e[1Gfoo bar\n",
      "\e[1G[          ]",
      "\e[1G[=         ]",
      "\e[1Gfoo bar     \n",
      "\e[1G[=         ]",
      "\e[1G[==        ]"
    ].join)
  end

  it "logs message under when complete" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 10)
    progress.advance(10)
    expect(progress.complete?).to eq(true)
    progress.log "foo bar"
    output.rewind
    expect(output.read).to eq("\e[1G[==========]\nfoo bar\n")
  end

  it "logs a message first with time and rate metrics" do
    Timecop.freeze(Time.local(2021, 1, 23, 12, 0, 0))
    format = "[:bar] :elapsed :eta :eta_time :rate/s"
    progress = TTY::ProgressBar.new(format, output: output, total: 10)

    3.times do |sec|
      Timecop.freeze(Time.local(2021, 1, 23, 12, 0, 1 + sec)) do
        progress.log "foo bar"
        progress.advance
      end
    end

    output.rewind
    expect(output.read).to eq([
      "\e[1Gfoo bar\n",
      "\e[1G[          ]  0s --s --:--:--  0.00/s", # render without starting
      "\e[1G[=         ]  0s  0s 12:00:01  1.00/s",
      "\e[1Gfoo bar                              \n",
      "\e[1G[=         ]  1s  9s 12:00:11  1.00/s", # render without advancing
      "\e[1G[==        ]  1s  4s 12:00:06  1.00/s",
      "\e[1Gfoo bar                              \n",
      "\e[1G[==        ]  2s  8s 12:00:11  1.00/s", # render without advancing
      "\e[1G[===       ]  2s  4s 12:00:07  1.00/s",
    ].join)
    Timecop.return
  end

  it "starts timer and logs a message with time and rate metrics" do
    Timecop.freeze(Time.local(2021, 1, 23, 12, 0, 0))
    format = "[:bar] :elapsed :eta :eta_time :rate/s"
    progress = TTY::ProgressBar.new(format, output: output, total: 10)

    Timecop.freeze(Time.local(2021, 1, 23, 12, 0, 1)) do
      progress.start
    end

    3.times do |sec|
      Timecop.freeze(Time.local(2021, 1, 23, 12, 0, 2 + sec)) do
        progress.log "foo bar"
        progress.advance
      end
    end

    output.rewind
    expect(output.read).to eq([
      "\e[1G[          ]  0s --s --:--:--  0.00/s", # render start
      "\e[1Gfoo bar                              \n",
      "\e[1G[          ]  1s  0s 12:00:02  0.00/s", # render without starting
      "\e[1G[=         ]  1s  9s 12:00:11  1.00/s",
      "\e[1Gfoo bar                              \n",
      "\e[1G[=         ]  2s 18s 12:00:21  1.00/s", # render without advancing
      "\e[1G[==        ]  2s  8s 12:00:11  1.00/s",
      "\e[1Gfoo bar                              \n",
      "\e[1G[==        ]  3s 12s 12:00:16  1.00/s", # render without advancing
      "\e[1G[===       ]  3s  7s 12:00:11  1.00/s",
    ].join)
    Timecop.return
  end
end
