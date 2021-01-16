# frozen_string_literal: true

RSpec.describe TTY::ProgressBar, "indeterminate" do
  let(:output) { StringIO.new }

  it "animates indeterminate progress and finishes" do
    progress = described_class.new("[:bar]", output: output, width: 10)
    104.times { progress.advance }

    progress.update(total: 110)
    6.times { progress.advance }

    output.rewind
    expect(output.read).to eq([
      "\e[1G[<=>       ]" * 3,
      "\e[1G[ <=>      ]" * 7,
      "\e[1G[  <=>     ]" * 7,
      "\e[1G[   <=>    ]" * 7,
      "\e[1G[    <=>   ]" * 8,
      "\e[1G[     <=>  ]" * 7,
      "\e[1G[      <=> ]" * 7,
      "\e[1G[       <=>]" * 7,
      "\e[1G[      <=> ]" * 7,
      "\e[1G[     <=>  ]" * 7,
      "\e[1G[    <=>   ]" * 8,
      "\e[1G[   <=>    ]" * 7,
      "\e[1G[  <=>     ]" * 7,
      "\e[1G[ <=>      ]" * 7,
      "\e[1G[<=>       ]" * 7,
      "\e[1G[ <=>      ]",
      "\e[1G[==========]" * 5,
      "\e[1G[==========]\n"
    ].join)
  end

  it "animates indeterminate progress with all metrics and finishes" do
    Timecop.freeze(Time.local(2021, 1, 16, 12, 0, 0))
    format = "[:bar] :current/:total :percent " \
             ":current_byte/:total_byte :byte_rate/s :mean_byte/s " \
             ":rate/s :mean_rate/s :elapsed :eta"

    progress = described_class.new(format, output: output, total: nil, width: 10)

    3.times do |sec|
      Timecop.freeze(Time.local(2021, 1, 16, 12, 0, 1 + sec))
      progress.advance
    end

    progress.update(total: 6)
    3.times do |i|
      Timecop.freeze(Time.local(2021, 1, 16, 12, 0, 4 + i))
      progress.advance
    end

    output.rewind
    expect(output.read).to eq([
      "\e[1G[<=>       ] 1/- -% 1B/-B 1B/s 1B/s  1.00/s  1.00/s  0s --s",
      "\e[1G[<=>       ] 2/- -% 2B/-B 1B/s 1B/s  1.00/s  1.00/s  1s --s",
      "\e[1G[<=>       ] 3/- -% 3B/-B 1B/s 1B/s  1.00/s  1.00/s  2s --s",
      "\e[1G[=======   ] 4/6 66% 4B/6B 1B/s 1B/s  1.00/s  1.00/s  3s  1s",
      "\e[1G[========  ] 5/6 83% 5B/6B 1B/s 1B/s  1.00/s  1.00/s  4s  0s",
      "\e[1G[==========] 6/6 100% 6B/6B 1B/s 1B/s  1.00/s  1.00/s  5s  0s\n"
    ].join)

    Timecop.return
  end
end
