RSpec.describe TTY::ProgressBar, '#start' do
  let(:output) { StringIO.new('', 'w+') }

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
end
