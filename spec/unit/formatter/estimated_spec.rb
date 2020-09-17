RSpec.describe TTY::ProgressBar, ":eta token" do
  let(:output) { StringIO.new("", "w+") }

  before { Timecop.safe_mode = false }

  it "displays elapsed time" do
    time_now = Time.local(2014, 10, 5, 12, 0, 0)
    Timecop.freeze(time_now)
    progress = TTY::ProgressBar.new(":eta", output: output, total: 5)

    5.times do |sec|
      time_now = Time.local(2014, 10, 5, 12, 0, sec)
      Timecop.freeze(time_now)
      progress.advance
    end

    output.rewind
    expect(output.read).to eq([
      "\e[1G 0s",
      "\e[1G 1s",
      "\e[1G 1s",
      "\e[1G 0s",
      "\e[1G 0s\n"
    ].join)
    Timecop.return
  end

  it "displays unknown elapsed time when no total" do
    time_now = Time.local(2014, 10, 5, 12, 0, 0)
    Timecop.freeze(time_now)
    progress = TTY::ProgressBar.new(":eta", output: output, total: nil)

    3.times { progress.advance }
    progress.update(total: 5)

    2.times do |sec|
      time_now = Time.local(2014, 10, 5, 12, 0, sec)
      Timecop.freeze(time_now)
      progress.advance
    end

    output.rewind
    expect(output.read).to eq([
      "\e[1G--s",
      "\e[1G--s",
      "\e[1G--s",
      "\e[1G 0s",
      "\e[1G 0s\n"
    ].join)
    Timecop.return
  end
end
