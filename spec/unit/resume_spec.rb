# frozen_string_literal: true

RSpec.describe TTY::ProgressBar, "#resume" do
  let(:output) { StringIO.new }

  it "resumes stopped progression" do
    progress = described_class.new("[:bar]", output: output, total: 10)

    3.times { progress.advance }
    progress.stop
    expect(progress.stopped?).to eq(true)

    progress.resume
    expect(progress.stopped?).to eq(false)
    3.times { progress.advance }

    output.rewind
    expect(output.read).to eq([
      "\e[1G[=         ]",
      "\e[1G[==        ]",
      "\e[1G[===       ]",
      "\e[1G[===       ]\n", # stop render
      "\e[1G[====      ]",
      "\e[1G[=====     ]",
      "\e[1G[======    ]"
    ].join)
  end

  it "resumes stopped progression with all the metrics" do
    time_now = Time.local(2021, 1, 9, 12, 0, 0)
    Timecop.freeze(time_now)
    format = "[:bar] :current/:total :percent " \
             ":current_byte/:total_byte :byte_rate/s :mean_byte/s " \
             ":rate/s :mean_rate/s :elapsed :eta"

    progress = described_class.new(format, output: output, total: 10)

    3.times do |i|
      time_now = Time.local(2021, 1, 9, 12, 0, 1 + i)
      Timecop.freeze(time_now)
      progress.advance
    end
    progress.stop
    expect(progress.stopped?).to eq(true)

    progress.resume
    expect(progress.stopped?).to eq(false)
    3.times do |i|
      time_now = Time.local(2021, 1, 9, 12, 0, 4 + i)
      Timecop.freeze(time_now)
      progress.advance
    end

    output.rewind
    expect(output.read).to eq([
      "\e[1G[=         ] 1/10 10% 1B/10B 1B/s 1B/s  1.00/s  1.00/s  0s  0s",
      "\e[1G[==        ] 2/10 20% 2B/10B 1B/s 1B/s  1.00/s  1.00/s  1s  4s",
      "\e[1G[===       ] 3/10 30% 3B/10B 1B/s 1B/s  1.00/s  1.00/s  2s  4s",
      "\e[1G[===       ] 3/10 30% 3B/10B 1B/s 1B/s  1.00/s  1.00/s  2s  4s\n", # stop render
      "\e[1G[====      ] 4/10 40% 4B/10B 1B/s 1B/s  1.00/s  1.00/s  3s  4s",
      "\e[1G[=====     ] 5/10 50% 5B/10B 1B/s 1B/s  1.00/s  1.00/s  4s  4s",
      "\e[1G[======    ] 6/10 60% 6B/10B 1B/s 1B/s  1.00/s  1.00/s  5s  3s"
    ].join)
  end
end
