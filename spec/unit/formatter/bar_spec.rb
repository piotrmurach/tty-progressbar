require 'pastel'
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

  it "properly handles the case of a large amount of work on a small bar that has colors for complete" do
    pastel = Pastel.new
    progress = TTY::ProgressBar.new("[:bar]",
      total: 1000,
      complete: pastel.on_green(' '),
      width: 80
    )
    expect{ 5.times { progress.advance(20) } }.to_not raise_error
  end
end
