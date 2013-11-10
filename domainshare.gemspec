# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'domainshare/version'

Gem::Specification.new do |spec|
  spec.name          = "domainshare"
  spec.version       = Domainshare::VERSION
  spec.authors       = ["Phillipp Röll"]
  spec.email         = ["phillipp.roell@trafficplex.de"]
  spec.description   = %q{.tk Domainshare API as rubygem}
  spec.summary       = %q{.tk Domainshare API as rubygem}
  spec.homepage      = "https://github.com/phillipp/domainshare"
  spec.license       = ""

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
