# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dealer/version'

Gem::Specification.new do |spec|
  spec.name          = 'dealer'
  spec.version       = Dealer::VERSION
  spec.authors       = ['Matt Daubert']
  spec.email         = ['mdaubert@gmail.com']

  spec.summary       = 'Framework for building card games in Ruby'
  spec.homepage      = 'https://github.com/mdaubs/dealer'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faye-websocket'
  spec.add_dependency 'logging'
  spec.add_dependency 'rack'
  spec.add_dependency 'thin'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-collection_matchers'
end
