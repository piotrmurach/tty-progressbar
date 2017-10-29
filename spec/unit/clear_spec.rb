RSpec.describe TTY::ProgressBar, 'clear' do
  let(:output) { StringIO.new('', 'w+') }

  it "clears progress bar when finished" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 5,
     clear: true)
    5.times { progress.advance }
    output.rewind
    expect(output.read).to eq([
      "\e[1G[=    ]",
      "\e[1G[==   ]",
      "\e[1G[===  ]",
      "\e[1G[==== ]",
      "\e[1G[=====]\e[0m\e[2K\e[1G"
    ].join)
  end
end
