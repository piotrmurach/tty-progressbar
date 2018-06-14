RSpec.describe TTY::ProgressBar, '#width' do
  let(:output) { StringIO.new('', 'w+') }

  it "handles width exceeding terminal width" do
    progress = TTY::ProgressBar.new "[:bar]" do |config|
      config.output = output
      config.total = 5
      config.width = 1024
    end
    allow(TTY::Screen).to receive(:width).and_return(20)
    5.times { progress.advance }
    output.rewind
    expect(output.read).to eq([
      "\e[1G[====              ]",
      "\e[1G[=======           ]",
      "\e[1G[===========       ]",
      "\e[1G[==============    ]",
      "\e[1G[==================]\n"
    ].join)
  end

  it "handles unicode characters width" do
    bar = TTY::ProgressBar.new("あめかんむり[:bar]", output: output, total: 20)
    allow(TTY::Screen).to receive(:width).and_return(20)
    4.times { bar.advance(5) }
    output.rewind
    expect(output.read).to eq([
      "\e[1Gあめかんむり[==    ]",
      "\e[1Gあめかんむり[===   ]",
      "\e[1Gあめかんむり[===== ]",
      "\e[1Gあめかんむり[======]\n"
    ].join)
  end
end
