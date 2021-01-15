# frozen_string_literal: false

RSpec.describe TTY::ProgressBar, ":bar_format" do
  let(:output) { StringIO.new("", "w+") }
  let(:formats) { TTY::ProgressBar::Formats::FORMATS }

  TTY::ProgressBar::Formats::FORMATS.each_key do |format|
    it "displays progress with #{format.inspect} format characters" do
      complete = formats[format][:complete]
      incomplete = formats[format][:incomplete]
      progress = TTY::ProgressBar.new("[:bar]", output: output, total: 10,
                                                bar_format: format)

      5.times { progress.advance(2) }

      output.rewind
      expect(output.read).to eq([
        "\e[1G[#{complete * 2}#{incomplete * 8}]",
        "\e[1G[#{complete * 4}#{incomplete * 6}]",
        "\e[1G[#{complete * 6}#{incomplete * 4}]",
        "\e[1G[#{complete * 8}#{incomplete * 2}]",
        "\e[1G[#{complete * 10}#{incomplete * 0}]\n"
      ].join)
    end

    it "displays unknown progress for #{format.inspect} bar format" do
      unknown = formats[format][:unknown]
      left_chars = 10 - unknown.size
      progress = TTY::ProgressBar.new("[:bar]", output: output, total: nil,
                                                bar_format: format, width: 10)

      2.times { progress.advance(2) }

      output.rewind
      expect(output.read).to eq([
        "\e[1G[#{unknown}#{' ' * left_chars}]",
        "\e[1G[#{unknown}#{' ' * left_chars}]"
      ].join)
    end
  end
end
