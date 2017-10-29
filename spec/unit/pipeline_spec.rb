RSpec.describe TTY::ProgressBar::Pipeline, '#decorate' do
  subject(:pipeline) { described_class.new }

  it "decorates tokenized string with pipeline formatters" do
    pipeline.use TTY::ProgressBar::CurrentFormatter
    pipeline.use TTY::ProgressBar::TotalFormatter
    progress_bar = double(current: '3', total: '10')
    tokenized = "[:current/:total]"
    expect(pipeline.decorate(progress_bar, tokenized)).to eq("[3/10]")
  end

  it "enumerates pipeline formatters" do
    pipeline.use TTY::ProgressBar::CurrentFormatter
    pipeline.use TTY::ProgressBar::TotalFormatter
    yielded = []
    pipeline.each { |formatter| yielded << formatter }
    expect(yielded.size).to eq(2)
  end
end
