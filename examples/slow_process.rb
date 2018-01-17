require_relative '../lib/tty-progressbar'

CONTENT_SIZE = 2048
CHUNK_SIZE = 255

# Dummy "long responding server"
def download_from_server(offset, limit)
  sleep(0.1)
  "<chunk #{offset}..#{offset + limit}>"
end

def download_finished?(position)
  position >= CONTENT_SIZE
end

downloader = Enumerator.new do |y|
  start = 0
  loop do
    y.yield(download_from_server(start, CHUNK_SIZE))
    start += CHUNK_SIZE
    raise StopIteration if download_finished?(start)
  end
end

bar = TTY::ProgressBar.new("[:bar] :current_byte/:total_byte", total: CONTENT_SIZE)

response = bar.iterate(downloader, CHUNK_SIZE).to_a.join

puts response
