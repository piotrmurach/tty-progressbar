# frozen_string_literal: true

require "erb"
require "rspec-benchmark"

RSpec.describe TTY::ProgressBar, "rendering" do
  include RSpec::Benchmark::Matchers

  let(:done) { "本" }
  let(:head) { "語" }
  let(:rem)  { "〜" }

  it "performs bar rendering slower than ERB template substitution" do
    output_progress = StringIO.new
    output_write = StringIO.new
    # Progress bar
    progress = TTY::ProgressBar.new("[:bar]", output: output_progress,
      incomplete: rem, head: head, complete: done, total: 5, width: 10)
    # ERB renderer
    template = "<%= done %> - <%= head %> - <%= rem %>"
    renderer = ERB.new(template)

    expect {
      progress.advance
      progress.reset
    }.to perform_slower_than {
      output_write << renderer.result(binding)
    }.at_most(10).times
  end

  it "performs bar rendering 2.4k i/s" do
    output = StringIO.new
    progress = described_class.new("[:bar]", output: output, total: 10,
                                             width: 10)

    expect {
      progress.advance
      progress.reset
    }.to perform_at_least(2400).ips
  end
end
