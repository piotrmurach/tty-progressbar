# frozen_string_literal: true

RSpec.describe TTY::ProgressBar, "#configure" do
  it "yields configuration instance" do
    progress = described_class.new(":bar")
    config = spy(:config)
    allow(progress).to receive(:configure).and_yield(config)

    expect { |block|
      progress.configure(&block)
    }.to yield_with_args(config)
  end

  it "overrides initial option configuration" do
    progress = described_class.new(":bar", total: 10)
    expect(progress.total).to eq(10)

    progress.configure do |config|
      config.total = 20
    end

    expect(progress.total).to eq(20)
  end

  %i[complete incomplete unknown].each do |option|
    it "fails to set #{option.inspect} to an empty string via initialize" do
      expect {
        described_class.new(":bar", total: 10, option => "")
      }.to raise_error(
        ArgumentError,
        "cannot provide an empty string for #{option.inspect}"
      )
    end

    it "fails to set #{option.inspect} to empty string via accessor" do
      progress = described_class.new(":bar", total: 10)

      expect {
        progress.configure do |config|
          config.public_send("#{option}=", "")
        end
      }.to raise_error(
        ArgumentError,
        "cannot provide an empty string for #{option.inspect}"
      )
    end
  end
end
