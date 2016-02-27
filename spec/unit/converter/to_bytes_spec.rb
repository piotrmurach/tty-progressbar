# encoding: utf-8

RSpec.describe TTY::ProgressBar::Converter, '#to_bytes' do
  subject(:converter) { described_class.new }

  it "converts 1000 to bytes" do
    expect(converter.to_bytes(1000)).to eq('1000B')
  end

  it "converts 1024 to bytes" do
    expect(converter.to_bytes(1024)).to eq('1.00KB')
  end

  it "converts 2000 to bytes" do
    expect(converter.to_bytes(2000)).to eq('1.95KB')
  end

  it "converts 10_000_000 to bytes" do
    expect(converter.to_bytes(10_000_000)).to eq('9.54MB')
  end

  it "convert 10_000_000_000 to bytes" do
    expect(converter.to_bytes(10_000_000_000)).to eq('9.31GB')
  end
end
