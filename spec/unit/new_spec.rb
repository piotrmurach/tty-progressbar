# frozen_string_literal: true

RSpec.describe TTY::ProgressBar, ".new" do
  let(:output) { StringIO.new }

  it "fails to initialize without a bar formatting string" do
    expect {
      TTY::ProgressBar.new(total: 10)
    }.to raise_error(
      ArgumentError,
      /Expected bar formatting string, got `{:?total(=>|: )10}` instead\./
    )
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
    progress = described_class.new("[:bar]", output: output, total: 10)
    progress.advance
    output.rewind
    expect(output.read).to eq("\e[1G[=         ]")
  end

  it "yields configuration to block" do
    progress = described_class.new "[:bar]" do |config|
      config.output = output
      config.total = 10
      config.width = 40
      config.interval = 30
      config.frequency = 1.5
      config.head = ">>"
      config.complete = "#"
      config.incomplete = "-"
      config.unknown = "?"
      config.clear = true
      config.clear_head = true
      config.hide_cursor = true
      config.bar_format = :block
    end

    expect(progress.output).to eq(output)
    expect(progress.total).to eq(10)
    expect(progress.width).to eq(40)
    expect(progress.clear).to eq(true)
    expect(progress.interval).to eq(30)
    expect(progress.frequency).to eq(1.5)
    expect(progress.head).to eq(">>")
    expect(progress.complete).to eq("#")
    expect(progress.incomplete).to eq("-")
    expect(progress.unknown).to eq("?")
    expect(progress.clear_head).to eq(true)
    expect(progress.hide_cursor).to eq(true)
    expect(progress.bar_format).to eq(:block)
  end

  it "raises error when bar format is set to unsupported type" do
    expect {
      described_class.new "[:bar]", bar_format: :unknown
    }.to raise_error(
      ArgumentError,
      "unsupported bar format: :unknown. Available formats are: " \
      ":arrow, :asterisk, :blade, :block, :box, :bracket, " \
      ":burger, :button, :chevron, :circle, :classic, :crate, :diamond, :dot, " \
      ":heart, :rectangle, :square, :star, :track, :tread, :triangle, :wave"
    )
  end

  it "overrides option configuration inside a block" do
    bar = described_class.new(":bar", complete: "#") do |config|
      config.complete = "x"
    end

    expect(bar.complete).to eq("x")
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
