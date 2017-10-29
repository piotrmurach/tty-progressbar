RSpec.describe TTY::ProgressBar, ':current_byte token' do
  let(:output) { StringIO.new('', 'w+') }

  it "displays bytes processed" do
    progress = described_class.new(":current_byte", output: output, total: 102_400)
    5.times { progress.advance(20_480) }
    output.rewind
    expect(output.read).to eq([
      "\e[1G20.00KB",
      "\e[1G40.00KB",
      "\e[1G60.00KB",
      "\e[1G80.00KB",
      "\e[1G100.00KB\n"
    ].join)
  end
end
