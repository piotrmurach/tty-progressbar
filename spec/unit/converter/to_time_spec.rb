RSpec.describe TTY::ProgressBar::Converter, '#to_time' do
  subject(:converter) { described_class }

  it "converts seconds to seconds" do
    expect(converter.to_time(15)).to eq("15s")
  end

  it "converts seconds to minutes" do
    expect(converter.to_time(100)).to eq(" 1m40s")
  end

  it "converts seconds to small hours" do
    expect(converter.to_time(3600)).to eq(" 1h 0m")
  end

  it "converts secodns to hours" do
    expect(converter.to_time(100 * 3600)).to eq("100h")
  end
end
