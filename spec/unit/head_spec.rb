RSpec.describe TTY::ProgressBar, ':head' do
  let(:output) { StringIO.new('', 'w+')}

  it "animates head" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, head: '>', total: 5)
    5.times { progress.advance }
    output.rewind
    expect(output.read).to eq([
      "\e[1G[>    ]",
      "\e[1G[=>   ]",
      "\e[1G[==>  ]",
      "\e[1G[===> ]",
      "\e[1G[====>]\n"
    ].join)
  end

  it "customises all output characters" do
    progress = TTY::ProgressBar.new("[:bar]",
      output: output,
      head: 'ᗧ',
      complete: '-', incomplete: '.', total: 5)
    5.times { progress.advance }
    output.rewind
    expect(output.read).to eq([
      "\e[1G[ᗧ....]",
      "\e[1G[-ᗧ...]",
      "\e[1G[--ᗧ..]",
      "\e[1G[---ᗧ.]",
      "\e[1G[----ᗧ]\n"
    ].join)
  end
end
