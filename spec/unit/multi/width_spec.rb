RSpec.describe TTY::ProgressBar::Multi, 'width' do
  let(:output) { StringIO.new('', 'w+') }
  let(:save)    { TTY::Cursor.save }
  let(:restore) { TTY::Cursor.restore }
  let(:top) { TTY::ProgressBar::Multi::DEFAULT_INSET[:top] }
  let(:middle) { TTY::ProgressBar::Multi::DEFAULT_INSET[:middle] }
  let(:bottom) { TTY::ProgressBar::Multi::DEFAULT_INSET[:bottom] }

  it "sets top level bar width to maximum columns when exceeds terminal width" do
    allow(TTY::Screen).to receive(:width).and_return(15)

    bars = TTY::ProgressBar::Multi.new("[:bar] main", output: output)

    bar1 = bars.register("[:bar] one", total: 20)
    bar2 = bars.register("[:bar] two", total: 20)

    bar1.advance(10)
    bar2.advance(10)

    output.rewind
    expect(output.read).to eq([
      "\e[1G#{top}[==    ] main\n",
      "\e[1G#{bottom}[===  ] one\n",
      save,
      "\e[2A",   # up 2 lines
      "\e[1G#{top}[===   ] main",
      restore,
      "\e[1G#{bottom}[===  ] two\n"
    ].join)

    bar1.advance(10)

    output.rewind
    expect(output.read).to eq([
      "\e[1G#{top}[==    ] main\n",
      "\e[1G#{bottom}[===  ] one\n",
      save,
      "\e[2A",   # up 2 lines
      "\e[1G#{top}[===   ] main",
      restore,
      "\e[1G#{bottom}[===  ] two\n",
      save,
      "\e[3A",   # up 3 lines
      "\e[1G#{top}[===== ] main",
      restore,
      save,
      "\e[2A",   # up 2 lines
      "\e[1G#{middle}[=====] one",
      restore,
      save,
      "\e[2A",   # up 2 lines
      "#{middle}\n", # bar finished
      restore
    ].join)

    bar2.advance(10)

    output.rewind
    expect(output.read).to eq([
      "\e[1G#{top}[==    ] main\n",
      "\e[1G#{bottom}[===  ] one\n",
      save,
      "\e[2A",   # up 2 lines
      "\e[1G#{top}[===   ] main",
      restore,
      "\e[1G#{bottom}[===  ] two\n",
      save,
      "\e[3A",   # up 3 lines
      "\e[1G#{top}[===== ] main",
      restore,
      save,
      "\e[2A",   # up 2 lines
      "\e[1G#{middle}[=====] one",
      restore,
      save,
      "\e[2A",   # up 2 lines
      "#{middle}\n", # bar finished
      restore,
      save,
      "\e[3A",   # up 3 lines
      "\e[1G#{top}[======] main",
      restore,
      save,
      "\e[3A",  # up 1 line
      "#{top}\n",
      restore,
      save,
      "\e[1A",  # up 1 line
      "\e[1G#{bottom}[=====] two",
      restore,
      save,
      "\e[1A",  # up 1 line
      "#{bottom}\n",
      restore
    ].join)
  end

  it "sets top level bar width to a custom value" do
    bars = TTY::ProgressBar::Multi.new("[:bar] main", output: output, width: 20)

    bar1 = bars.register("[:bar] one", total: 20)
    bar2 = bars.register("[:bar] two", total: 20)

    bar1.advance(10)
    bar2.advance(10)

    output.rewind
    expect(output.read).to eq([
      "\e[1G#{top}[=====               ] main\n",
      "\e[1G#{bottom}[==========          ] one\n",
      save,
      "\e[2A",   # up 2 lines
      "\e[1G#{top}[==========          ] main",
      restore,
      "\e[1G#{bottom}[==========          ] two\n"
    ].join)
  end
end
