RSpec.describe TTY::ProgressBar, ':total token' do
  let(:output) { StringIO.new('', 'w+') }

  it "displays bytes total" do
    progress = described_class.new(":total", output: output, total: 102_400)
    5.times { progress.advance(20_480) }
    output.rewind
    expect(output.read).to eq([
      "\e[1G102400",
      "\e[1G102400",
      "\e[1G102400",
      "\e[1G102400",
      "\e[1G102400\n"
    ].join)
  end
end
