# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'allpaylogistics/version'

Gem::Specification.new do |spec|
  spec.name          = 'allpay_logistics'
  spec.version       = Allpay::VERSION
  spec.authors       = ['John Liu']
  spec.email         = ['johnliu33@gmail.com']
  spec.summary       = '歐付寶物流（Allpay Logistics）API 包裝'
  spec.description   = '歐付寶物流（Allpay Logistics）API 包裝'
  spec.homepage      = "https://github.com/johnliu33/allpay_logistics"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "sinatra"
end
