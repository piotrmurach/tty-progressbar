# frozen_string_literal: true

RSpec.describe TTY::ProgressBar, ":total_byte token" do
  let(:output) { StringIO.new }

  it "displays bytes total" do
    progress = described_class.new(":total_byte", output: output, total: 102_400)
    5.times { progress.advance(20_480) }
    output.rewind
    expect(output.read).to eq([
      "\e[1G100.00KB",
      "\e[1G100.00KB",
      "\e[1G100.00KB",
      "\e[1G100.00KB",
      "\e[1G100.00KB\n"
    ].join)
  end

  it "displays unknown bytes progress without total" do
    progress = described_class.new(":total_byte", output: output, total: nil)
    3.times { progress.advance(20_480) }
    progress.update(total: 102_400)
    2.times { progress.advance(20_480) }
    output.rewind
    expect(output.read).to eq([
      "\e[1G-B",
      "\e[1G-B",
      "\e[1G-B",
      "\e[1G100.00KB",
      "\e[1G100.00KB\n"
    ].join)
  end
end
