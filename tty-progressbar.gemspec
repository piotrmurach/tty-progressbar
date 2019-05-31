lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tty/progressbar/version'

Gem::Specification.new do |spec|
  spec.name          = "tty-progressbar"
  spec.version       = TTY::ProgressBar::VERSION
  spec.authors       = ["Piotr Murach"]
  spec.email         = ["me@piotrmurach.com"]
  spec.summary       = %q{A flexible progress bars drawing in terminal emulators.}
  spec.description   = %q{A flexible progress bars drawing in terminal emulators.}
  spec.homepage      = "https://piotrmurach.github.io/tty/"
  spec.license       = "MIT"

  spec.files         = Dir['{lib,spec,examples}/**/*.rb']
  spec.files        += Dir['tasks/*', 'tty-progressbar.gemspec']
  spec.files        += Dir['README.md', 'CHANGELOG.md', 'LICENSE.txt', 'Rakefile']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency 'strings-ansi', '~> 0.1.0'
  spec.add_dependency 'tty-cursor', '~> 0.7'
  spec.add_dependency 'tty-screen', '~> 0.7'
  spec.add_dependency 'unicode-display_width', '~> 1.6'

  spec.add_development_dependency 'bundler', '>= 1.5.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'timecop', '~> 0.9.1'
  spec.add_development_dependency 'rake'
end
