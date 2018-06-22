RSpec.describe TTY::ProgressBar::Multi, '#reset' do
  let(:output) { StringIO.new('', 'w+') }

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
    expect(progress_updates.shift).to match(top)
    expect(progress_updates.shift).to match(bottom)
    expect(progress_updates.shift).to match(bottom)
    expect(progress_updates.shift).to match(bottom)
    expect(progress_updates.shift).to match(bottom)

    expect(progress_updates).to be_empty
  end
end
