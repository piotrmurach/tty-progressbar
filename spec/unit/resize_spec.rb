RSpec.describe TTY::ProgressBar, '#resize' do
  let(:output) { StringIO.new('', 'w+') }

  it "resizes output down by x2" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 5, width: 10)
    2.times { progress.advance }
    progress.resize(5)
    3.times { progress.advance }
    output.rewind
    expect(output.read).to eq([
      "\e[1G[==        ]",
      "\e[1G[====      ]",
      "\e[0m\e[2K\e[1G",
      "\e[1G[===  ]     ",
      "\e[1G[==== ]",
      "\e[1G[=====]\n"
    ].join)
  end

  it "resizes output up by x2" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 5, width: 10)
    2.times { progress.advance }
    progress.resize(20)
    3.times { progress.advance }
    output.rewind
    expect(output.read).to eq([
      "\e[1G[==        ]",
      "\e[1G[====      ]",
      "\e[0m\e[2K\e[1G",
      "\e[1G[============        ]",
      "\e[1G[================    ]",
      "\e[1G[====================]\n"
    ].join)
  end
end
