RSpec.describe TTY::ProgressBar, '#ratio=' do
  let(:output) { StringIO.new('', 'w+') }

  it "allows to set ratio" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 10)
    progress.ratio = 0.7
    expect(progress.current).to eq(7)
    output.rewind
    expect(output.read).to eq([
      "\e[1G[=======   ]"
    ].join)
  end

  it "finds closest available step from the ratio" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 3)
    progress.ratio = 0.5
    expect(progress.current).to eq(1)
  end

  it "doesn't allow to set wrong ratio" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 3)
    progress.ratio = 3.2
    expect(progress.current).to eq(3)
    expect(progress.complete?).to eq(true)
  end

  it "avoids division by zero" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 0)
    expect(progress.ratio).to eq(0)
  end
end
