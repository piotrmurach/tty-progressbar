RSpec.describe TTY::ProgressBar::Pipeline, '#decorate' do
  subject(:pipeline) { described_class.new }

  it "decorates tokenized string with pipeline formatters" do
    progress_bar = double(current: '3', total: '10')
    pipeline.use TTY::ProgressBar::CurrentFormatter.new(progress_bar)
    pipeline.use TTY::ProgressBar::TotalFormatter.new(progress_bar)
    tokenized = "[:current/:total]"
    expect(pipeline.decorate(tokenized)).to eq("[3/10]")
  end

  it "enumerates pipeline formatters" do
    progress_bar = double(current: '3', total: '10')
    pipeline.use TTY::ProgressBar::CurrentFormatter.new(progress_bar)
    pipeline.use TTY::ProgressBar::TotalFormatter.new(progress_bar)
    yielded = []
    pipeline.each { |formatter| yielded << formatter }
    expect(yielded.size).to eq(2)
  end
end
