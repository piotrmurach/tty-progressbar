# coding: utf-8

RSpec.describe TTY::ProgressBar::Meter, '.rate' do

  before { Timecop.safe_mode = false }

  after { Timecop.return }

  it "measures rate per second" do
    meter = TTY::ProgressBar::Meter.new(1)
    meter.start
    time_now = Time.local(2014, 10, 5, 12, 0, 0)
    Timecop.freeze(time_now)

    # First sample batch
    time_now = Time.local(2014, 10, 5, 12, 0, 0, 100)
    meter.sample time_now, 1000
    expect(meter.rate).to eq(1000)
    expect(meter.mean_rate).to eq(1000)

    time_now = Time.local(2014, 10, 5, 12, 0, 0, 200)
    meter.sample time_now, 2000
    expect(meter.rate).to eq(1500)
    expect(meter.mean_rate).to eq(1500)

    time_now = Time.local(2014, 10, 5, 12, 0, 0, 300)
    meter.sample time_now, 1000
    expect(meter.rate).to be_within(0.5).of(1333)
    expect(meter.mean_rate).to be_within(0.5).of(1333)

    # Second sample batch after 1s
    time_now = Time.local(2014, 10, 5, 12, 0, 1, 400)
    meter.sample time_now, 500
    expect(meter.rate).to eq(500)
    expect(meter.mean_rate).to eq(2250)

    time_now = Time.local(2014, 10, 5, 12, 0, 1, 500)
    meter.sample time_now, 500
    expect(meter.rate).to eq(500)
    expect(meter.mean_rate).to eq(2500)

    # Third sample batch after 3s
    time_now = Time.local(2014, 10, 5, 12, 0, 2, 600)
    meter.sample time_now, 3000
    expect(meter.rate).to eq(3000)
    expect(meter.mean_rate).to be_within(0.7).of(2666)

    time_now = Time.local(2014, 10, 5, 12, 0, 2, 700)
    meter.sample time_now, 3000
    expect(meter.rate).to eq(3000)
    expect(meter.mean_rate).to be_within(0.7).of(3666)
  end

  it "clears measurements" do
    meter = TTY::ProgressBar::Meter.new(1)
    meter.start
    time_now = Time.local(2014, 10, 5, 12, 0, 0)
    Timecop.freeze(time_now)

    time_now = Time.local(2014, 10, 5, 12, 0, 0, 100)
    meter.sample time_now, 1000
    expect(meter.rates).to eq([1000])
    expect(meter.rate).to eq(1000)

    meter.clear
    expect(meter.rates).to eq([])
    expect(meter.rate).to eq(0)
  end
end
