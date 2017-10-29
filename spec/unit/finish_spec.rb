RSpec.describe TTY::ProgressBar, '#finish' do
  let(:output) { StringIO.new('', 'w+') }

  it 'finishes progress' do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 10)
    progress.advance
    progress.finish
    expect(progress.complete?).to be(true)
    output.rewind
    expect(output.read).to eq([
      "\e[1G[=         ]",
      "\e[1G[==========]\n"
    ].join)
  end
end
