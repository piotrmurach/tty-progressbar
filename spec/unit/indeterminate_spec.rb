# frozen_string_literal: true

RSpec.describe TTY::ProgressBar, "indeterminate" do
  let(:output) { StringIO.new }

  it "animates indeterminate progress" do
    progress = described_class.new("[:bar]", output: output, width: 10)
    104.times { progress.advance }

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
      "\e[1G[ <=>      ]"
    ].join)
  end
end
