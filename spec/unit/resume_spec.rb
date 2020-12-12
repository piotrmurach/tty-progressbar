RSpec.describe TTY::ProgressBar, "#resume" do
  let(:output) { StringIO.new("", "w+") }

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
      "\e[1G[======    ]",
    ].join)
  end
end
