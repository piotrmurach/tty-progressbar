RSpec.describe TTY::ProgressBar, ':bar token' do
  let(:output) { StringIO.new('', 'w+') }

  it "animates bar" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 5)
    5.times { progress.advance }
    output.rewind
    expect(output.read).to eq([
      "\e[1G[=    ]",
      "\e[1G[==   ]",
      "\e[1G[===  ]",
      "\e[1G[==== ]",
      "\e[1G[=====]\n"
    ].join)
  end

  it "animates colors correctly" do
    red = "\e[31m \e[0m"
    green = "\e[32m \e[0m"
    progress = TTY::ProgressBar.new("[:bar]", total: 5, complete: green,
                                    incomplete: red, output: output)

    5.times { progress.advance }
    output.rewind
    expect(output.read).to eq([
      "\e[1G[#{green}#{red}#{red}#{red}#{red}]",
      "\e[1G[#{green}#{green}#{red}#{red}#{red}]",
      "\e[1G[#{green}#{green}#{green}#{red}#{red}]",
      "\e[1G[#{green}#{green}#{green}#{green}#{red}]",
      "\e[1G[#{green}#{green}#{green}#{green}#{green}]\n",
    ].join)
  end
end
