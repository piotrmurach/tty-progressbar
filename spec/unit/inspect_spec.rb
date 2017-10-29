RSpec.describe TTY::ProgressBar, '#inspect' do
  it "inspects bar properties" do
    bar = described_class.new("downloading [:bar] :total", total: 30)
    expect(bar.inspect).to eq(%q{#<TTY::ProgressBar @format="downloading [:bar] :total", @current="0", @total="30", @width="30", @complete="=", @head="=", @incomplete=" ", @interval="1">})
  end

  it "prints string format" do
    bar = described_class.new("downloading [:bar] :total", total: 30)
    expect(bar.to_s).to eq("downloading [:bar] :total")
  end
end
