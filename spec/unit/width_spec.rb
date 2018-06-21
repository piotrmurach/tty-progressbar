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

  it "handles unicode characters width in formatting string" do
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

  it "handles unicodes characters within bar" do
    bar = TTY::ProgressBar.new("[:bar]", output: output, total: 20,
                                         complete: 'あ', incomplete: 'め')
    allow(TTY::Screen).to receive(:width).and_return(20)

    4.times { bar.advance(5) }
    output.rewind

    expect(output.read).to eq([
      "\e[1G[あああめめめめめめ]",
      "\e[1G[あああああめめめめ]",
      "\e[1G[あああああああめめ]",
      "\e[1G[あああああああああ]\n"
    ].join)
  end

  it "handles unicodes characters within bar" do
    bar = TTY::ProgressBar.new("[:bar]", output: output, total: 20,
                                         complete: 'あ', incomplete: ' ')
    allow(TTY::Screen).to receive(:width).and_return(20)

    4.times { bar.advance(5) }
    output.rewind

    expect(output.read).to eq([
      "\e[1G[あああ            ]",
      "\e[1G[あああああ        ]",
      "\e[1G[あああああああ    ]",
      "\e[1G[あああああああああ]\n"
    ].join)
  end

  it "handles unicodes characters within bar" do
    bar = TTY::ProgressBar.new("[:bar]", output: output, total: 20,
                                         complete: 'x', incomplete: 'め')
    allow(TTY::Screen).to receive(:width).and_return(20)

    4.times { bar.advance(5) }
    output.rewind

    expect(output.read).to eq([
      "\e[1G[xxxxxめめめめめめ]",
      "\e[1G[xxxxxxxxxめめめめ]",
      "\e[1G[xxxxxxxxxxxxxxめめ]",
      "\e[1G[xxxxxxxxxxxxxxxxxx]\n"
    ].join)
  end
end
