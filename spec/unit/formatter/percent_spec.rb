RSpec.describe TTY::ProgressBar, ':percent token' do
  let(:output) { StringIO.new('', 'w+') }

  it "displays percent finished" do
    progress = TTY::ProgressBar.new(":percent", output: output, total: 5)
    5.times { progress.advance }
    output.rewind
    expect(output.read).to eq([
      "\e[1G20%",
      "\e[1G40%",
      "\e[1G60%",
      "\e[1G80%",
      "\e[1G100%\n"
    ].join)
  end
end
