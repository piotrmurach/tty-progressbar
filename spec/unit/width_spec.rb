# coding: utf-8

require 'spec_helper'

RSpec.describe TTY::ProgressBar, 'width' do
  let(:output) { StringIO.new('', 'w+') }

  it "handles width exceeding terminal width" do
    progress = TTY::ProgressBar.new "[:bar]" do |config|
      config.output = output
      config.total = 5
      config.width = 1024
    end
    screen = double(:screen, width: 20)
    allow(TTY::Screen).to receive(:new).and_return(screen)
    5.times { progress.advance }
    output.rewind
    expect(output.read).to eq([
      "\e[1G[====              ]",
      "\e[1G[=======           ]",
      "\e[1G[===========       ]",
      "\e[1G[==============    ]",
      "\e[1G[==================]\n"
    ].join)
  end
end
