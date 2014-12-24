# coding: utf-8

require 'spec_helper'

RSpec.describe TTY::ProgressBar, 'ratio=' do
  let(:output) { StringIO.new('', 'w+') }

  it "allows to set ratio" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 10)
    progress.ratio = 0.7
    expect(progress.current).to eq(7)
    output.rewind
    expect(output.read).to eq([
      "\e[1G[=======   ]"
    ].join)
  end

  it "finds closest available step from the ratio" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 3)
    progress.ratio = 0.5
    expect(progress.current).to eq(1)
  end
end
