# frozen_string_literal: true

RSpec.describe TTY::ProgressBar::Converter, "#to_time" do
  subject(:converter) { described_class }

  it "converts zero seconds" do
    expect(converter.to_time(0.0)).to eq(" 0s")
  end

  it "converts less than a second to zero" do
    expect(converter.to_time(0.83)).to eq(" 0s")
  end

  it "converts seconds to a second" do
    expect(converter.to_time(1.2)).to eq(" 1s")
  end

  it "converts seconds to seconds" do
    expect(converter.to_time(15)).to eq("15s")
  end

  it "converts seconds to a minute" do
    expect(converter.to_time(100)).to eq(" 1m40s")
  end

  it "converts seconds to minutes" do
    expect(converter.to_time(2000)).to eq("33m20s")
  end

  it "converts seconds to an hour" do
    expect(converter.to_time(3600)).to eq(" 1h 0m")
  end

  it "converts seconds to hours" do
    expect(converter.to_time(23.5 * 3600)).to eq("23h30m")
  end

  it "converts seconds to days and hours" do
    expect(converter.to_time(100 * 3600)).to eq("4d 4h 0m")
  end
end
