# coding: utf-8

require 'spec_helper'

RSpec.describe TTY::ProgressBar, '.advance' do
  let(:output) { StringIO.new('', 'w+') }

  it "allows to go back" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 10)
    5.times { progress.advance(1) }
    expect(progress.current).to eq(5)
    5.times { progress.advance(-1) }
    expect(progress.current).to eq(0)
  end

  it "cannot backtrack on finished" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 10)
    10.times { progress.advance(1) }
    expect(progress.current).to eq(10)
    5.times { progress.advance(-1) }
    expect(progress.current).to eq(10)
  end
end
