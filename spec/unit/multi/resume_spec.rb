RSpec.describe TTY::ProgressBar::Multi.new, "#resume" do
  let(:output) { StringIO.new('', 'w+') }
  let(:save)    { TTY::Cursor.save }
  let(:restore) { TTY::Cursor.restore }
  let(:top) { TTY::ProgressBar::Multi::DEFAULT_INSET[:top] }
  let(:middle) { TTY::ProgressBar::Multi::DEFAULT_INSET[:middle] }
  let(:bottom) { TTY::ProgressBar::Multi::DEFAULT_INSET[:bottom] }

  it "resumes top bar when new bar registered and advanced" do
    top_bar = TTY::ProgressBar::Multi.new("[:bar] top (:current/:total)", output: output)

    bar1 = top_bar.register("[:bar] one", total: 5)
    bar1. advance(5)

    expect(top_bar.done?).to eq(true)
    expect(bar1.done?).to eq(true)

    bar2 = top_bar.register("[:bar] two", total: 5)
    bar2.advance

    output.rewind
    expect(output.string).to eq([
      "\e[1G#{top}[=====] top (5/5)\n",
      save,
      "\e[1A",
      "#{top}\n",
      restore,
      "\e[1G#{bottom}[=====] one\n",
      save,
      "\e[1A#{bottom}\n",
      restore,
      save,
      "\e[2A", # up 2 lines
      "\e[1G#{top}[======    ] top (6/10)",
      restore,
      "\e[1G#{bottom}[=    ] two\n"
    ].join)

    expect(top_bar.done?).to eq(false)
    expect(bar1.done?).to eq(true)
    expect(bar2.done?).to eq(false)
  end
end
