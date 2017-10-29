RSpec.describe TTY::ProgressBar::Converter, '#to_seconds' do
  subject(:converter) { described_class }

  it "ensure 5 digit precision for < 1" do
    expect(converter.to_seconds(0.000005)).to eq("0.00001")
  end

  it "rounds 0 to 0.00" do
    expect(converter.to_seconds(0)).to eq(" 0.00")
  end

  it "ensures 2 digit precision for > 1" do
    expect(converter.to_seconds(11.2)).to eq("11.20")
  end
end
