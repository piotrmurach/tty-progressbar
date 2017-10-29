RSpec.describe TTY::ProgressBar, ':bar token' do
  let(:output) { StringIO.new('', 'w+') }

  it "animates bar" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 5)
    5.times { progress.advance }
    output.rewind
    expect(output.read).to eq([
      "\e[1G[=    ]",
      "\e[1G[==   ]",
      "\e[1G[===  ]",
      "\e[1G[==== ]",
      "\e[1G[=====]\n"
    ].join)
  end
end
