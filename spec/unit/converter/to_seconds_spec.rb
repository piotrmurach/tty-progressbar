# frozen_string_literal: true

RSpec.describe TTY::ProgressBar::Converter, "#to_seconds" do
  subject(:converter) { described_class }

  it "ensures 5-digit precision for < 1",
     unless: RSpec::Support::Ruby.truffleruby? do
    expect(converter.to_seconds(0.000005)).to eq("0.00001")
  end

  it "ensures 5-digit precision for < 1 on TruffleRuby",
     if: RSpec::Support::Ruby.truffleruby? do
    expect(converter.to_seconds(0.000005)).to eq("0.00000")
  end

  it "rounds 0 to 0.00" do
    expect(converter.to_seconds(0)).to eq(" 0.00")
  end

  it "ensures 2-digit precision for > 1" do
    expect(converter.to_seconds(11.2)).to eq("11.20")
  end

  it "specifies precision to be 3 digits" do
    expect(converter.to_seconds(11.12345, precision: 3)).to eq("11.123")
  end
end
