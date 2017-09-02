# encoding: utf-8

RSpec.describe TTY::ProgressBar::Multi, 'advance' do
  let(:output) { StringIO.new('', 'w+') }
  let(:save)    { TTY::Cursor.save }
  let(:restore) { TTY::Cursor.restore }

  it "advances progress bars correctly under multibar" do
    bars = TTY::ProgressBar::Multi.new(output: output)

    bar1 = bars.register("[:bar] one", total: 5)
    bar2 = bars.register("[:bar] two", total: 5)

    bar2.advance
    bar1.advance

    output.rewind
    expect(output.read).to eq([
      "\e[1G[=    ] two\n",
      "\e[1G[=    ] one\n"
    ].join)

    bar2.advance

    output.rewind
    expect(output.read).to eq([
      "\e[1G[=    ] two\n",
      "\e[1G[=    ] one\n",
      save,
      "\e[2A", # up 2 lines
      "\e[1G[==   ] two",
      restore
    ].join)

    bar1.advance

    output.rewind
    expect(output.read).to eq([
      "\e[1G[=    ] two\n",
      "\e[1G[=    ] one\n",
      save,
      "\e[2A", # up 2 lines
      "\e[1G[==   ] two",
      restore,
      save,
      "\e[1A", # up 1 line
      "\e[1G[==   ] one",
      restore
    ].join)
  end
end
