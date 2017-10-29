RSpec.describe TTY::ProgressBar, '#log' do
  let(:output) { StringIO.new('', 'w+') }

  it "logs message" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 10)
    2.times {
      progress.log 'foo bar'
      progress.advance
    }
    output.rewind
    expect(output.read).to eq([
      "\e[1Gfoo bar\n",
      "\e[1G[          ]",
      "\e[1G[=         ]",
      "\e[1Gfoo bar     \n",
      "\e[1G[=         ]",
      "\e[1G[==        ]",
    ].join)
  end

  it "logs message under when complete" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 10)
    progress.advance(10)
    expect(progress.complete?).to eq(true)
    progress.log 'foo bar'
    output.rewind
    expect(output.read).to eq("\e[1G[==========]\nfoo bar\n")
  end
end
