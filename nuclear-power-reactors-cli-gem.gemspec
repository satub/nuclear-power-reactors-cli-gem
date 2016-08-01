# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name          = "nuclear-power-reactors-cli-gem"
  spec.version       = Nuclear_Power_Reactors_CLI_GEM::VERSION
  spec.authors       = ["Satu Barnhill"]
  spec.email         = ["satu.barnhill@gmail.com"]

  spec.summary       = %q{CLI GEM for listing nuclear reactor data from information provided on IAEA.org public resources.}
  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/satub/nuclear-power-reactors-cli-gem"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| f[3..-1] }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
