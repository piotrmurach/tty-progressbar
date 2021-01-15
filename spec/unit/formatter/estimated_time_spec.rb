# frozen_string_literal: true

RSpec.describe TTY::ProgressBar, ":eta_time token" do
  let(:output) { StringIO.new }

  before { Timecop.safe_mode = false }

  after { Timecop.return }

  it "displays estimated completion time of day" do
    time_now = Time.local(2020, 1, 5, 12, 0, 0)
    Timecop.freeze(time_now)
    bar = described_class.new(" :eta_time", output: output, total: 5)

    5.times do |sec|
      time_now = Time.local(2020, 1, 5, 12, 0, sec)
      Timecop.freeze(time_now)
      bar.advance
    end

    output.rewind
    expect(output.read).to eq([
      "\e[1G 12:00:00",
      "\e[1G 12:00:02",
      "\e[1G 12:00:03",
      "\e[1G 12:00:03",
      "\e[1G 12:00:04\n"
    ].join)
  end

  it "displays estimated completion time of day with date after 24 hours" do
    time_now = Time.local(2020, 1, 5, 12, 0, 0)
    Timecop.freeze(time_now)
    bar = described_class.new(" :eta_time", output: output, total: 5)

    2.times do |day|
      time_now = Time.local(2020, 1, day + 6, 12, 0, 0)
      Timecop.freeze(time_now)
      bar.advance
    end

    output.rewind
    expect(output.read).to eq([
      "\e[1G 12:00:00",
      "\e[1G 2020-01-09 00:00:00"
    ].join)
  end

  it "displays unknown estimated completion time of day as --:--:--" do
    time_now = Time.local(2020, 1, 5, 12, 0, 0)
    Timecop.freeze(time_now)
    bar = described_class.new(" :eta_time", output: output, total: nil)

    3.times { bar.advance }
    bar.update(total: 5)

    2.times do |sec|
      time_now = Time.local(2020, 1, 5, 12, 0, sec)
      Timecop.freeze(time_now)
      bar.advance
    end

    output.rewind
    expect(output.read).to eq([
      "\e[1G --:--:--",
      "\e[1G --:--:--",
      "\e[1G --:--:--",
      "\e[1G 12:00:00",
      "\e[1G 12:00:01\n"
    ].join)
  end
end
