# coding: utf-8

require 'spec_helper'

RSpec.describe TTY::ProgressBar, '.log' do
  let(:output) { StringIO.new('', 'w+') }

  it "logs message" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 10)
    2.times {
      progress.log 'foo bar'
      progress.advance
    }
    output.rewind
    expect(output.read).to eq([
      "\e[1Gfoo bar\n",
      "\e[1G[          ]",
      "\e[1G[=         ]",
      "\e[1Gfoo bar     \n",
      "\e[1G[=         ]",
      "\e[1G[==        ]",
    ].join)
  end
end
