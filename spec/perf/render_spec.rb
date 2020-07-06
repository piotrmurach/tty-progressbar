# frozen_string_literal: true

require "rspec-benchmark"

RSpec.describe TTY::ProgressBar, "rendering" do
  include RSpec::Benchmark::Matchers

  let(:done) { "本" }
  let(:head) { "語" }
  let(:rem)  { "〜" }

  it "performs bar rendering slower than template substitution" do
    output_progress = StringIO.new
    output_write = StringIO.new

    progress = TTY::ProgressBar.new("[:bar]", output: output_progress,
      incomplete: rem, head: head, complete: done, total: 5, width: 10)
    template = "%s %s %s"

    expect {
      progress.advance
      progress.reset
    }.to perform_slower_than {
      output_write << (template % [rem, head, done])
      output_write.rewind
    }.at_most(200).times
  end
end
