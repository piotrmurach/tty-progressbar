require_relative '../lib/tty-progressbar'

files = [
  'file1.txt', 'file2.txt', 'file3.txt', 'file4.txt', 'file5.txt',
  'file6.txt', 'file7.txt', 'file8.txt', 'file9.txt', 'file10.txt'
]

bar = TTY::ProgressBar.new("downloading :file :percent", total: files.size)
10.times do |num|
  sleep(0.1)
  bar.advance(file: files[num])
end
