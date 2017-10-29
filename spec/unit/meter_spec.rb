RSpec.describe TTY::ProgressBar::Meter, '#rate' do

  before { Timecop.safe_mode = false }

  after { Timecop.return }

  it "measures with no samples" do
    meter = TTY::ProgressBar::Meter.new(1)

    meter.start

    expect(meter.rate).to eq(0)
    expect(meter.mean_rate).to eq(0)
  end

  it "measures with a single sample" do
    meter = TTY::ProgressBar::Meter.new(1)
    start_time = Time.at(10, 0)
    Timecop.freeze(start_time)
    meter.start

    meter.sample(Time.at(10, 100_000), 10)

    expect(meter.rate).to eq(100)
    expect(meter.mean_rate).to eq(100)
  end

  it "measures rate per second" do
    meter = TTY::ProgressBar::Meter.new(1)
    start_time = Time.at(10, 0)
    Timecop.freeze(start_time)
    meter.start

    # First sample batch
    meter.sample Time.at(10, 100_000), 5
    expect(meter.rate).to eq(50)
    expect(meter.mean_rate).to eq(50)

    meter.sample Time.at(10, 500_000), 5
    expect(meter.rate).to eq(20)
    expect(meter.mean_rate).to eq(20)

    meter.sample Time.at(11, 000_000), 5
    expect(meter.rate).to eq(15)
    expect(meter.mean_rate).to eq(15)

    meter.sample Time.at(11, 500_000), 5
    expect(meter.rate).to eq(10)
    expect(meter.mean_rate).to be_within(0.001).of(13.333)

    meter.sample Time.at(12, 000_000), 10
    expect(meter.rate).to eq(15)
    expect(meter.mean_rate).to eq(15)
  end

  it "clears measurements" do
    meter = TTY::ProgressBar::Meter.new(1)
    start_time = Time.at(10, 0)
    Timecop.freeze(start_time)
    meter.start

    meter.sample(start_time + 1, 1000)
    expect(meter.rates).to eq([1000, 1000])
    expect(meter.rate).to eq(1000)

    meter.clear
    expect(meter.rates).to eq([0])
    expect(meter.rate).to eq(0)
  end
end
