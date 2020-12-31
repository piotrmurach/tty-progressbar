# frozen_string_literal: true

RSpec.describe TTY::ProgressBar, ":total token" do
  let(:output) { StringIO.new }

  it "displays total amount" do
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

  it "displays unknown progress without total" do
    progress = described_class.new(":total", output: output, total: nil)
    3.times { progress.advance(20_480) }
    progress.update(total: 102_400)
    2.times { progress.advance(20_480) }
    output.rewind
    expect(output.read).to eq([
      "\e[1G-",
      "\e[1G-",
      "\e[1G-",
      "\e[1G102400",
      "\e[1G102400\n"
    ].join)
  end
end
