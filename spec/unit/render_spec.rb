RSpec.describe TTY::ProgressBar, "#render" do
  let(:output) { StringIO.new("", "w+") }

  it "pads out longer previous lines" do
    progress = TTY::ProgressBar.new ":current_byte" do |config|
      config.no_width = true
      config.output   = output
      config.total    = 1_048_577
    end

    progress.advance(1)
    progress.advance(1_048_574)
    progress.advance(1)
    progress.advance(1)

    output.rewind

    expect(output.read).to eq([
      "\e[1G1B",
      "\e[1G1024.00KB", # must not pad, line is longer
      "\e[1G1.00MB   ", # must pad out "0KB"
      "\e[1G1.00MB",    # must not pad, line is equal
    ].join)
  end
end
