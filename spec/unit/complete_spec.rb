RSpec.describe TTY::ProgressBar, '#complete?' do
  let(:output) { StringIO.new('', 'w+') }

  it "checks for completness" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 3)
    completes = []
    3.times do
      completes << progress.complete?
      progress.advance
    end
    completes << progress.complete?
    expect(completes).to eq([
      false, false, false, true
    ])
  end
end
