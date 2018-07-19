lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tty/progressbar/version'

Gem::Specification.new do |spec|
  spec.name          = "tty-progressbar"
  spec.version       = TTY::ProgressBar::VERSION
  spec.authors       = ["Piotr Murach"]
  spec.email         = [""]
  spec.summary       = %q{A flexible progress bars drawing in terminal emulators.}
  spec.description   = %q{A flexible progress bars drawing in terminal emulators.}
  spec.homepage      = "https://piotrmurach.github.io/tty/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency 'tty-cursor', '~> 0.5.0'
  spec.add_dependency 'tty-screen', '~> 0.6.4'
  spec.add_dependency 'unicode-display_width', '~> 1.3'

  spec.add_development_dependency 'bundler', '>= 1.5.0', '< 2.0'
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'timecop', '~> 0.9.1'
  spec.add_development_dependency 'rake'
end
