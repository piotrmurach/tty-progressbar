# frozen_string_literal: true

RSpec.describe TTY::ProgressBar, ":eta token" do
  let(:output) { StringIO.new }

  before { Timecop.safe_mode = false }

  after { Timecop.return }

  it "displays elapsed time" do
    Timecop.freeze(Time.local(2014, 10, 5, 12, 0, 0))
    progress = TTY::ProgressBar.new(":eta", output: output, total: 5)

    5.times do |sec|
      Timecop.freeze(Time.local(2014, 10, 5, 12, 0, sec))
      progress.advance
    end

    output.rewind
    expect(output.read).to eq([
      "\e[1G 0s",
      "\e[1G 1s",
      "\e[1G 1s",
      "\e[1G 0s",
      "\e[1G 0s\n"
    ].join)
  end

  it "displays unknown elapsed time when no total" do
    Timecop.freeze(Time.local(2014, 10, 5, 12, 0, 0))
    progress = TTY::ProgressBar.new(":eta", output: output, total: nil)

    3.times { progress.advance }
    progress.update(total: 5)

    2.times do |sec|
      Timecop.freeze(Time.local(2014, 10, 5, 12, 0, sec))
      progress.advance
    end

    output.rewind
    expect(output.read).to eq([
      "\e[1G--s",
      "\e[1G--s",
      "\e[1G--s",
      "\e[1G 0s",
      "\e[1G 0s\n"
    ].join)
  end
end
