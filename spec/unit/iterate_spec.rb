RSpec.describe TTY::ProgressBar, '#iterate' do
  let(:output) { StringIO.new('', 'w+') }

  it "iterates over a collection and yields" do
    bar = TTY::ProgressBar.new("[:bar]", output: output)
    values = []
    bar.iterate(5.times) { |val| values << val}

    expect(bar.complete?).to eq(true)
    output.rewind
    expect(output.read).to eq([
      "\e[1G[=    ]",
      "\e[1G[==   ]",
      "\e[1G[===  ]",
      "\e[1G[==== ]",
      "\e[1G[=====]\n"
    ].join)
    expect(values).to eq([0, 1, 2, 3, 4])
  end

  it "iterates over a collection with a step" do
    bar = TTY::ProgressBar.new("[:bar]", output: output)
    bar.iterate(20.times, 5) {  }

    expect(bar.complete?).to eq(true)
    output.rewind
    expect(output.read).to eq([
      "\e[1G[=====               ]",
      "\e[1G[==========          ]",
      "\e[1G[===============     ]",
      "\e[1G[====================]\n"
    ].join)
  end

  it "iterates over a collection and returns enumerable" do
    bar = TTY::ProgressBar.new("[:bar]", output: output)
    values = []
    progress = bar.iterate(5.times)

    expect(bar.complete?).to eq(false)

    progress.each { |v| values << v }

    expect(values).to eq([0,1,2,3,4])
  end
end
