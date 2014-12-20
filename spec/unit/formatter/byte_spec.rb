# coding: utf-8

require 'spec_helper'

RSpec.describe TTY::ProgressBar, '.new' do
  let(:output) { StringIO.new('', 'w+') }

  it "displays bytes processed" do
    progress = described_class.new(":byte", output: output, total: 100_000)
    5.times { progress.advance(20_000) }
    output.rewind
    expect(output.read).to eq([
      "\e[1G19.53KB",
      "\e[1G39.06KB",
      "\e[1G58.59KB",
      "\e[1G78.12KB",
      "\e[1G97.66KB\n"
    ].join)
  end
end
