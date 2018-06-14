RSpec.describe TTY::ProgressBar, '#reset' do
  let(:output) { StringIO.new('', 'w+') }

  it "resets current progress" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 10)
    progress.advance(5)
    progress.reset
    2.times { progress.advance(3) }
    output.rewind
    expect(output.read).to eq([
      "\e[1G[=====     ]",
      "\e[1G[===       ]",
      "\e[1G[======    ]"
    ].join)
  end

  it "resets finished progress" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 10)
    progress.advance(10)
    expect(progress.complete?).to be(true)
    progress.reset
    expect(progress.complete?).to be(false)
    2.times { progress.advance(3) }
    output.rewind
    expect(output.read).to eq([
      "\e[1G[==========]\n",
      "\e[1G[===       ]",
      "\e[1G[======    ]"
    ].join)
  end

  it "leaves multibar state alone" do
    main = TTY::ProgressBar::Multi.new("", output: output, total: 10)
    progress = main.register("[:bar]")
    progress.advance(10)
    expect(progress.complete?).to be(true)
    progress.reset
    expect(progress.complete?).to be(false)
    progress.advance(10)
    output.rewind

    top    = TTY::ProgressBar::Multi::DEFAULT_INSET[:top]
    bottom = TTY::ProgressBar::Multi::DEFAULT_INSET[:bottom]

    progress_updates =
      output.read.scan(/#{Regexp.escape top}|#{Regexp.escape bottom}/)
    expect(progress_updates.shift).to match(top)
    expect(progress_updates.shift).to match(bottom)
    expect(progress_updates.shift).to match(bottom)
    expect(progress_updates.shift).to match(top)
    expect(progress_updates.shift).to match(bottom)
    expect(progress_updates.shift).to match(bottom)

    expect(progress_updates).to be_empty
  end
end
