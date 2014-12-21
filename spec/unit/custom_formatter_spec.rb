# coding: utf-8

require 'spec_helper'

RSpec.describe TTY::ProgressBar, 'custom' do
  let(:output) { StringIO.new('', 'w+') }

  it "allows for custom tag" do
    progress = TTY::ProgressBar.new(":hi", output: output, total: 10)

    HiFormatter = Class.new do
      def initialize(progress)
        @progress = progress
      end

      def matches?(value)
        value.to_s =~ /:hi/
      end

      def format(value)
        value.gsub(/:hi/, "Hello")
      end
    end

    progress.use(HiFormatter)
    progress.advance
    output.rewind
    expect(output.read).to eq("\e[1GHello")
  end
end
