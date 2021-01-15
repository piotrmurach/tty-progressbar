# frozen_string_literal: true

RSpec.describe TTY::ProgressBar, ":head" do
  let(:output) { StringIO.new }

  it "animates head" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, head: ">", total: 5)
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
    progress = TTY::ProgressBar.new(
      "[:bar]",
      output: output,
      head: "ᗧ",
      complete: "-", incomplete: ".", total: 5
    )
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

  it "exceeds 2 characters" do
    progress = TTY::ProgressBar.new(
      "[:bar]",
      output: output,
      head: ">>>",
      complete: "-", incomplete: ".", total: 20
    )
    5.times { progress.advance(4) }
    output.rewind
    expect(output.read).to eq([
      "\e[1G[->>>................]",
      "\e[1G[----->>>............]",
      "\e[1G[--------->>>........]",
      "\e[1G[------------->>>....]",
      "\e[1G[----------------->>>]\n"
    ].join)
  end

  it "clears head after finishing" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 5,
                                              head: ">", clear_head: true)
    5.times { progress.advance }
    output.rewind
    expect(output.read).to eq([
      "\e[1G[>    ]",
      "\e[1G[=>   ]",
      "\e[1G[==>  ]",
      "\e[1G[===> ]",
      "\e[1G[=====]\n"
    ].join)
  end
end
