require_relative "lib/tty/progressbar/version"

Gem::Specification.new do |spec|
  spec.name          = "tty-progressbar"
  spec.version       = TTY::ProgressBar::VERSION
  spec.authors       = ["Piotr Murach"]
  spec.email         = ["piotr@piotrmurach.com"]
  spec.summary       = %q{A flexible progress bars drawing in terminal emulators.}
  spec.description   = %q{A flexible progress bars drawing in terminal emulators.}
  spec.homepage      = "https://ttytoolkit.org"
  spec.license       = "MIT"
  if spec.respond_to?(:metadata=)
    spec.metadata = {
      "allowed_push_host" => "https://rubygems.org",
      "bug_tracker_uri"   => "https://github.com/piotrmurach/tty-progressbar/issues",
      "changelog_uri"     => "https://github.com/piotrmurach/tty-progressbar/blob/master/CHANGELOG.md",
      "documentation_uri" => "https://www.rubydoc.info/gems/tty-progressbar",
      "homepage_uri"      => spec.homepage,
      "source_code_uri"   => "https://github.com/piotrmurach/tty-progressbar"
    }
  end
  spec.files         = Dir["lib/**/*", "README.md", "CHANGELOG.md", "LICENSE.txt"]
  spec.extra_rdoc_files = ["README.md", "CHANGELOG.md"]
  spec.bindir        = "exe"
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.0.0"

  spec.add_dependency "strings-ansi", "~> 0.2"
  spec.add_dependency "tty-cursor", "~> 0.7"
  # spec.add_dependency "tty-screen", "~> 0.7"
  spec.add_dependency "unicode-display_width", "~> 1.6"
end
