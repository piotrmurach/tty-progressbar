RSpec.describe TTY::ProgressBar, '#hide_cursor' do
  let(:output) { StringIO.new('', 'w+') }

  it "hides cursor" do
    progress = TTY::ProgressBar.new("[:bar]", output: output,
      total: 5, hide_cursor: true)
    5.times { progress.advance }
    output.rewind
    expect(output.read).to eq([
      "\e[?25l\e[1G[=    ]",
      "\e[1G[==   ]",
      "\e[1G[===  ]",
      "\e[1G[==== ]",
      "\e[1G[=====]\n\e[?25h"
    ].join)
  end

  it "reenables cursor on finish" do
    progress = TTY::ProgressBar.new("[:bar]", output: output,
      total: 5, hide_cursor: true)

    progress.advance(6)
    expect(progress.complete?).to eq(true)
    output.rewind
    expect(output.read).to eq("\e[1G[=====]\n\e[?25h")
  end
end
