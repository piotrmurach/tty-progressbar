RSpec.describe TTY::ProgressBar, 'custom token' do
  let(:output) { StringIO.new('', 'w+') }

  it "allows to specify custom tokens" do
    progress = TTY::ProgressBar.new("(:current) :title", output: output, total: 4)
    progress.advance(title: 'Hello Piotr!')
    progress.advance(3, title: 'Bye Piotr!')
    output.rewind
    expect(output.read).to eq([
      "\e[1G(1) Hello Piotr!",
      "\e[1G(4) Bye Piotr!  \n"
    ].join)
  end
end
