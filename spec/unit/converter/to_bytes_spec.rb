RSpec.describe TTY::ProgressBar::Converter, '#to_bytes' do
  subject(:converter) { described_class }

  it "converts 1000 to bytes" do
    expect(converter.to_bytes(1000)).to eq('1000B')
  end

  it "converts 1024 to bytes" do
    expect(converter.to_bytes(1024)).to eq('1.00KB')
  end

  it "converts 1234 to bytes" do
    expect(converter.to_bytes(1234)).to eq('1.21KB')
  end

  it "converts 12345 to bytes" do
    expect(converter.to_bytes(12345)).to eq('12.06KB')
  end

  it "converts 2000 to bytes" do
    expect(converter.to_bytes(2000)).to eq('1.95KB')
  end

  it "converts 1234567 to bytes" do
    expect(converter.to_bytes(1234567)).to eq('1.18MB')
  end

  it "converts 1234567 to bytes with :separator" do
    expect(converter.to_bytes(1234567, separator: ',')).to eq('1,18MB')
  end

  it "converts 1234567 to bytes with :unit_separator" do
    expect(converter.to_bytes(1234567, unit_separator: ' ')).to eq('1.18 MB')
  end

  it "converts 1234567 to bytes with comma as a separator" do
    expect(converter.to_bytes(1234567, decimals: 1)).to eq('1.2MB')
  end

  it "converts 10_000_000 to bytes" do
    expect(converter.to_bytes(10_000_000)).to eq('9.54MB')
  end

  it "convert 10_000_000_000 to bytes" do
    expect(converter.to_bytes(10_000_000_000)).to eq('9.31GB')
  end
end
