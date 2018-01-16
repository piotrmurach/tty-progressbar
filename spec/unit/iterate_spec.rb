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
    values = []
    bar.iterate(4.times, 5) { |val| values << val }

    expect(bar.complete?).to eq(true)
    output.rewind
    expect(output.read).to eq([
      "\e[1G[=====               ]",
      "\e[1G[==========          ]",
      "\e[1G[===============     ]",
      "\e[1G[====================]\n"
    ].join)
    expect(values).to eq([0, 1, 2, 3])
  end

  it "iterates over a collection and returns enumerable" do
    bar = TTY::ProgressBar.new("[:bar]", output: output)
    values = []
    progress = bar.iterate(5.times)

    expect(bar.complete?).to eq(false)

    progress.each { |v| values << v }

    expect(values).to eq([0,1,2,3,4])
  end

  it "does not uses collection's count if total is provided" do
    bar = TTY::ProgressBar.new("[:bar]", output: output, total: 5)
    iterable = 5.times
    expect(iterable).not_to receive(:count)
    progress = bar.iterate(iterable)
    values = []

    progress.each { |v| values << v }

    expect(values).to eq([0,1,2,3,4])
  end

  it "iterates over an infinite enumerator and renders bar correctly" do
    bar = TTY::ProgressBar.new("[:bar]", output: output, total: 5)
    infinite_iter = (1..Float::INFINITY).lazy

    progress = bar.iterate(infinite_iter)

    10.times { progress.next }

    expect(bar.complete?).to eq(true)
    output.rewind
    expect(output.read).to eq([
      "\e[1G[=    ]",
      "\e[1G[==   ]",
      "\e[1G[===  ]",
      "\e[1G[==== ]",
      "\e[1G[=====]\n"
    ].join)
  end
end
