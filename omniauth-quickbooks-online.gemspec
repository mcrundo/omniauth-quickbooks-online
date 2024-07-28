lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "omniauth-quickbooks-online/version"

Gem::Specification.new do |spec|
  spec.name          = "omniauth-quickbooks-online"
  spec.version       = OmniAuth::QuickbooksOnline::VERSION
  spec.authors       = ["various"]
  spec.email         = ["job@bluth.co"]

  spec.summary       = 'OAuth2 Omniauth strategy for Quickbooks.'
  spec.description   = 'OAuth2 Omniauth straetgy for Quickbooks (Intuit) API.'
  spec.homepage      = 'https://github.com/CanalWestStudio/omniauth-quickbooks-online'
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split("\n")
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'omniauth'
  spec.add_dependency 'omniauth-oauth2'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3"
end
