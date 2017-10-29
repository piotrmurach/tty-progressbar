RSpec.describe TTY::ProgressBar, ':current token' do
  let(:output) { StringIO.new('', 'w+') }

  it "displays current value" do
    progress = TTY::ProgressBar.new("|:current|", output: output, total: 10)
    3.times { progress.advance }
    output.rewind
    expect(output.read).to eq([
      "\e[1G|1|",
      "\e[1G|2|",
      "\e[1G|3|"
    ].join)
  end
end
