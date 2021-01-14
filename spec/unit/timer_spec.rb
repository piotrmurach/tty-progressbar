# frozen_string_literal: true

RSpec.describe TTY::ProgressBar::Timer do
  before { Timecop.safe_mode = false }

  after { Timecop.return }

  it "defaults elapsed time to zero" do
    timer = described_class.new

    expect(timer.elapsed_time).to eq(0)
  end

  it "doesn't run timer until started" do
    timer = described_class.new

    expect(timer.running?).to eq(false)
    expect(timer.start_time).to eq(nil)
  end

  it "returns 0 when calling stop when not running" do
    timer = described_class.new
    expect(timer.stop).to eq(0)
  end

  it "measures elapsed time for a single interval when stopped" do
    timer = described_class.new
    start_time = Time.at(10, 0)
    Timecop.freeze(start_time)
    expect(timer.start).to eq(start_time)
    expect(timer.start_time).to eq(start_time)

    Timecop.freeze(Time.at(10, 500_000))
    expect(timer.stop).to eq(0.5)
    expect(timer.elapsed_time).to eq(0.5)
    expect(timer.running?).to eq(false)
    expect(timer.start_time).to eq(nil)
  end

  it "measures elapsed time for a single interval when still running" do
    timer = described_class.new
    start_time = Time.at(10, 0)
    Timecop.freeze(start_time)
    expect(timer.start).to eq(start_time)

    Timecop.freeze(Time.at(10, 500_000))
    expect(timer.elapsed_time).to eq(0.5)
    expect(timer.running?).to eq(true)
    expect(timer.start_time).to eq(start_time)
  end

  it "measures the total elapsed time for multiple intervals when stopped" do
    timer = described_class.new

    Timecop.freeze(Time.at(10, 0))
    timer.start

    Timecop.freeze(Time.at(10, 500_000))
    expect(timer.stop).to eq(0.5)
    expect(timer.elapsed_time).to eq(0.5)

    Timecop.freeze(Time.at(11, 000_000))
    timer.start

    Timecop.freeze(Time.at(11, 500_000))
    expect(timer.stop).to eq(0.5)
    expect(timer.elapsed_time).to eq(1)
    expect(timer.running?).to eq(false)
  end

  it "measures the total elapsed time for multiple intervals when still running" do
    timer = described_class.new

    Timecop.freeze(Time.at(10, 0))
    timer.start

    Timecop.freeze(Time.at(10, 500_000))
    expect(timer.stop).to eq(0.5)
    expect(timer.elapsed_time).to eq(0.5)

    Timecop.freeze(Time.at(11, 000_000))
    timer.start

    Timecop.freeze(Time.at(11, 500_000))
    expect(timer.stop).to eq(0.5)
    expect(timer.elapsed_time).to eq(1)

    Timecop.freeze(Time.at(12, 000_000))
    timer.start

    Timecop.freeze(Time.at(12, 500_000))
    expect(timer.elapsed_time).to eq(1.5)
    expect(timer.running?).to eq(true)
  end

  it "resets time measurements" do
    timer = described_class.new
    start_time = Time.at(10, 0)
    Timecop.freeze(start_time)
    timer.start

    Timecop.freeze(Time.at(12, 500_000))

    expect(timer.elapsed_time).to eq(2.5)
    expect(timer.running?).to eq(true)
    expect(timer.start_time).to eq(start_time)

    timer.reset

    expect(timer.elapsed_time).to eq(0)
    expect(timer.running?).to eq(false)
    expect(timer.start_time).to eq(nil)
  end
end
