RSpec.describe TTY::ProgressBar, '#stop' do
  let(:output) { StringIO.new('', 'w+') }

  it 'stops progress' do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 10)
    5.times { |i|
      progress.stop if i == 3
      progress.advance
    }
    expect(progress.complete?).to be(false)
    output.rewind
    expect(output.read).to eq([
      "\e[1G[=         ]",
      "\e[1G[==        ]",
      "\e[1G[===       ]",
      "\e[1G[===       ]\n"
    ].join)
  end
end
