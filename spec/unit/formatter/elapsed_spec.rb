# frozen_string_literal: true

RSpec.describe TTY::ProgressBar, ":elapsed token" do
  let(:output) { StringIO.new }

  before { Timecop.safe_mode = false }

  it "displays elapsed time" do
    time_now = Time.local(2014, 10, 5, 12, 0, 0)
    Timecop.freeze(time_now)
    progress = TTY::ProgressBar.new(":elapsed", output: output, total: 10)

    5.times do |sec|
      time_now = Time.local(2014, 10, 5, 12, 0, sec)
      Timecop.freeze(time_now)
      progress.advance
    end

    output.rewind
    expect(output.read).to eq([
      "\e[1G 0s",
      "\e[1G 1s",
      "\e[1G 2s",
      "\e[1G 3s",
      "\e[1G 4s"
    ].join)
    Timecop.return
  end

  it "resets elapsed time" do
    time_now = Time.local(2014, 10, 5, 12, 0, 0)
    Timecop.freeze(time_now)
    progress = TTY::ProgressBar.new(":elapsed", output: output, total: 5)

    5.times do |sec|
      time_now = Time.local(2014, 10, 5, 12, 0, sec)
      Timecop.freeze(time_now)
      progress.advance
    end
    expect(progress.complete?).to be(true)
    progress.reset
    2.times do |sec|
      time_now = Time.local(2014, 10, 5, 13, 0, sec)
      Timecop.freeze(time_now)
      progress.advance
    end

    output.rewind
    expect(output.read).to eq([
      "\e[1G 0s",
      "\e[1G 1s",
      "\e[1G 2s",
      "\e[1G 3s",
      "\e[1G 4s\n",
      "\e[1G 0s",
      "\e[1G 1s"
    ].join)
    Timecop.return
  end

  it "resumes elapsed time measurement when stopped or finished" do
    time_now = Time.local(2021, 1, 10, 12, 0, 0)
    Timecop.freeze(time_now)
    progress = TTY::ProgressBar.new(":elapsed", output: output, total: 10)

    5.times do |sec|
      time_now = Time.local(2021, 1, 10, 12, 0, 1 + sec)
      Timecop.freeze(time_now)
      progress.advance
    end

    progress.stop
    progress.resume

    3.times do |sec| # resume progression after 5 seconds
      time_now = Time.local(2021, 1, 10, 12, 0, 10 + sec)
      Timecop.freeze(time_now)
      progress.advance
    end

    progress.finish
    progress.update(total: 12)
    progress.resume

    2.times do |sec| # resume progression after 2 seconds
      time_now = Time.local(2021, 1, 10, 12, 0, 15 + sec)
      Timecop.freeze(time_now)
      progress.advance
    end

    output.rewind
    expect(output.read).to eq([
      "\e[1G 0s",
      "\e[1G 1s",
      "\e[1G 2s",
      "\e[1G 3s",
      "\e[1G 4s",
      "\e[1G 4s\n", # stopped
      "\e[1G 4s",
      "\e[1G 5s",
      "\e[1G 6s",
      "\e[1G 6s\n", # finished
      "\e[1G 6s",
      "\e[1G 7s\n",
    ].join)
    Timecop.return
  end
end
