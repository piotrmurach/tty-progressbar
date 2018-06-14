RSpec.describe TTY::ProgressBar, '::new' do
  let(:output) { StringIO.new('', 'w+') }

  it "fails to initialize without formatting string" do
    expect {
      TTY::ProgressBar.new(output: output)
    }.to raise_error(ArgumentError, /Expected bar formatting string, got `{:output=>#{output}}` instead\./)
  end

  it "allows to change formatting string" do
    bar = TTY::ProgressBar.new("[:bar]", output: output, total: 4)
    bar.advance(2)
    bar.format = "(:bar)"
    bar.advance(2)
    output.rewind

    expect(output.read).to eq("\e[1G[==  ]\e[1G(====)\n")
  end

  it "displays output where width == total" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 10)
    progress.advance
    output.rewind
    expect(output.read).to eq("\e[1G[=         ]")
  end

  it "yields configuration to block" do
    progress = TTY::ProgressBar.new "[:bar]" do |config|
      config.output = output
      config.total  = 10
      config.clear  = true
    end
    expect(progress.output).to eq(output)
    expect(progress.total).to eq(10)
    expect(progress.width).to eq(10)
    expect(progress.clear).to eq(true)
  end

  it "displays output where width > total" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 5, width: 10)
    5.times { progress.advance }
    output.rewind
    expect(output.read).to eq([
      "\e[1G[==        ]",
      "\e[1G[====      ]",
      "\e[1G[======    ]",
      "\e[1G[========  ]",
      "\e[1G[==========]\n"
    ].join)
  end

  it "displays output where width < total" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 10, width: 5)
    10.times { progress.advance }
    output.rewind
    expect(output.read).to eq([
      "\e[1G[=    ]",
      "\e[1G[=    ]",
      "\e[1G[==   ]",
      "\e[1G[==   ]",
      "\e[1G[===  ]",
      "\e[1G[===  ]",
      "\e[1G[==== ]",
      "\e[1G[==== ]",
      "\e[1G[=====]",
      "\e[1G[=====]\n"
    ].join)
  end

  it "displays total value" do
    progress = TTY::ProgressBar.new("|:total|", output: output, total: 10)
    progress.advance(3)
    output.rewind
    expect(output.read).to eq("\e[1G|10|")
  end
end
