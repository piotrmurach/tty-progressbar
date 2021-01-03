# frozen_string_literal: true

class OutputIO
  def initialize(content = "")
    @content = content
  end

  def print(string)
    @content += string
  end

  def read
    @content
  end

  def flush; end

  def rewind; end

  def tty?
    true
  end
end
