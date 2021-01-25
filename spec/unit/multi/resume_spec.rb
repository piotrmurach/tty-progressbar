# frozen_string_literal: true

RSpec.describe TTY::ProgressBar::Multi, "#resume" do
  let(:output) { StringIO.new }
  let(:save)    { TTY::Cursor.save }
  let(:restore) { TTY::Cursor.restore }
  let(:top) { TTY::ProgressBar::Multi::DEFAULT_INSET[:top] }
  let(:middle) { TTY::ProgressBar::Multi::DEFAULT_INSET[:middle] }
  let(:bottom) { TTY::ProgressBar::Multi::DEFAULT_INSET[:bottom] }

  it "resumes top bar when new bar registered and advanced" do
    top_bar = described_class.new("[:bar] top (:current/:total)", output: output)

    bar1 = top_bar.register("[:bar] one", total: 5)
    bar1.advance(5)

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

  it "resumes all paused bars" do
    bars = described_class.new("[:bar] top (:current/:total)", output: output)

    bar1 = bars.register("[:bar] one", total: 5)
    bar2 = bars.register("[:bar] two", total: 5)

    bar1.pause

    bar1.advance
    bar2.advance

    expect(bar1.paused?).to eq(true)
    expect(bar2.paused?).to eq(false)
    expect(bars.paused?).to eq(false)

    output.rewind
    expect(output.string).to eq([
      "\e[1G#{top}[=         ] top (1/10)\n",
      "\e[1G#{bottom}[=    ] two\n"
    ].join)

    bars.resume
    bar1.advance
    bar2.advance

    expect(bar1.paused?).to eq(false)
    expect(bar2.paused?).to eq(false)
    expect(bars.paused?).to eq(false)

    output.rewind
    expect(output.string).to eq([
      save,
      "\e[2A", # up 2 lines
      "\e[1G#{top}[==        ] top (2/10)",
      restore,
      "\e[1G#{bottom}[=    ] one\n",
      save,
      "\e[3A", # up 3 lines
      "\e[1G#{top}[===       ] top (3/10)",
      restore,
      save,
      "\e[2A", # up 2 lines
      "\e[1G#{middle}[==   ] two",
      restore
    ].join)
  end
end
