RSpec.describe TTY::ProgressBar, ':rate token' do
  let(:output) { StringIO.new('', 'w+') }

  before { Timecop.safe_mode = false }

  it "shows current rate per sec" do
    time_now = Time.local(2014, 10, 5, 12, 0, 0)
    Timecop.freeze(time_now)
    progress = TTY::ProgressBar.new(":rate", output: output, total: 100, interval: 1)
    # Generate a serie of advances at 2s intervals
    #   t+0     advance=0       total=0
    #   t+2     advance=10      total=10
    #   t+4     advance=20      total=30
    #   t+6     advance=30      total=60
    #   t+8     advance=40      total=100
    5.times do |i|
      time_now = Time.local(2014, 10, 5, 12, 0, i * 2)
      Timecop.freeze(time_now)
      progress.advance(i * 10)
    end
    output.rewind
    expect(output.read).to eq([
      "\e[1G 0.00",
      "\e[1G 5.00",
      "\e[1G10.00",
      "\e[1G15.00",
      "\e[1G20.00\n"
    ].join)
    Timecop.return
  end
end
