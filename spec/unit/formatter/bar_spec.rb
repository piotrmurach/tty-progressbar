RSpec.describe TTY::ProgressBar, ':bar token' do
  let(:output) { StringIO.new('', 'w+') }

  it "animates bar" do
    progress = TTY::ProgressBar.new("[:bar]", output: output, total: 5)
    5.times { progress.advance }
    output.rewind
    expect(output.read).to eq([
      "\e[1G[=    ]",
      "\e[1G[==   ]",
      "\e[1G[===  ]",
      "\e[1G[==== ]",
      "\e[1G[=====]\n"
    ].join)
  end

  it "animates colors correctly" do
    red = "\e[31m \e[0m"
    green = "\e[32m \e[0m"
    progress = TTY::ProgressBar.new("[:bar]", total: 5, complete: green,
                                    incomplete: red, output: output)

    5.times { progress.advance }
    output.rewind
    expect(output.read).to eq([
      "\e[1G[#{green}#{red}#{red}#{red}#{red}]",
      "\e[1G[#{green}#{green}#{red}#{red}#{red}]",
      "\e[1G[#{green}#{green}#{green}#{red}#{red}]",
      "\e[1G[#{green}#{green}#{green}#{green}#{red}]",
      "\e[1G[#{green}#{green}#{green}#{green}#{green}]\n",
    ].join)
  end

  describe "when unicode chars & odd width" do
    let(:done) { '本' }
    let(:head) { '語' }
    let(:rem)  { '〜' }

    it "head, complete & incomplete are unicode chars" do
      progress = TTY::ProgressBar.new("[:bar]", output: output,
        incomplete: rem, head: head, complete: done, total: 5, width: 9)

      5.times { progress.advance }
      output.rewind

      expect(output.read).to eq([
        "\e[1G[語〜〜〜]",
        "\e[1G[本語〜〜]",
        "\e[1G[本語〜〜]",
        "\e[1G[本本語〜]",
        "\e[1G[本本本語]\n"
      ].join)
    end

    it "head & complete unicode chars vs incomplete ascii char" do
      progress = TTY::ProgressBar.new("[:bar]", output: output,
        incomplete: "-", head: head, complete: done, total: 5, width: 9)

      5.times { progress.advance }
      output.rewind

      expect(output.read).to eq([
        "\e[1G[語------]",
        "\e[1G[本語----]",
        "\e[1G[本語----]",
        "\e[1G[本本語--]",
        "\e[1G[本本本語]\n"
      ].join)
    end

    it "head & complete ascii chars vs incomplete unicode char" do
      progress = TTY::ProgressBar.new("[:bar]", output: output,
        incomplete: rem, head: ">", complete: "#", total: 5, width: 9)

      5.times { progress.advance }
      output.rewind

      expect(output.read).to eq([
        "\e[1G[##>〜〜〜]",
        "\e[1G[####>〜〜]",
        "\e[1G[####>〜〜]",
        "\e[1G[######>〜]",
        "\e[1G[########>]\n"
      ].join)
    end

    it "complete ascii chars vs head & incomplete unicode char" do
      progress = TTY::ProgressBar.new("[:bar]", output: output,
        incomplete: rem, head: head, complete: "#", total: 5, width: 9)

      5.times { progress.advance }
      output.rewind

      expect(output.read).to eq([
        "\e[1G[#語〜〜〜]",
        "\e[1G[###語〜〜]",
        "\e[1G[###語〜〜]",
        "\e[1G[#####語〜]",
        "\e[1G[#######語]\n"
      ].join)
    end

    it "head & incomplete ascii chars vs complete unicode char" do
      progress = TTY::ProgressBar.new("[:bar]", output: output,
        incomplete: "-", head: ">", complete: done, total: 5, width: 9)

      5.times { progress.advance }
      output.rewind

      expect(output.read).to eq([
        "\e[1G[>------]",
        "\e[1G[本>----]",
        "\e[1G[本>----]",
        "\e[1G[本本>--]",
        "\e[1G[本本本>]\n"
      ].join)
    end

    it "head ascii char vs complete & incomplete unicode chars" do
      progress = TTY::ProgressBar.new("[:bar]", output: output,
        incomplete: rem, head: ">", complete: done, total: 5, width: 9)

      5.times { progress.advance }
      output.rewind

      expect(output.read).to eq([
        "\e[1G[>〜〜〜]",
        "\e[1G[本>〜〜]",
        "\e[1G[本>〜〜]",
        "\e[1G[本本>〜]",
        "\e[1G[本本本>]\n"
      ].join)
    end
  end
end
