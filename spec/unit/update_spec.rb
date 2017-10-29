RSpec.describe TTY::ProgressBar, '#update' do
  let(:output) { StringIO.new('', 'w+') }

  it "updates bar configuration options" do
    progress = TTY::ProgressBar.new "[:bar]" do |config|
      config.output = output
      config.total = 10
    end
    10.times { |i|
      progress.update(complete: '-', head: '>') if i == 2
      progress.advance(2)
    }
    output.rewind
    expect(output.read).to eq([
      "\e[1G[==        ]",
      "\e[1G[====      ]",
      "\e[1G[----->    ]",
      "\e[1G[------->  ]",
      "\e[1G[--------->]\n"
    ].join)
  end
end
