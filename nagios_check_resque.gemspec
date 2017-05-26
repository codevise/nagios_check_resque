# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nagios_check_resque/version'

Gem::Specification.new do |spec|
  spec.name          = 'nagios_check_resque'
  spec.version       = NagiosCheckResque::VERSION
  spec.authors       = ['Codevise Solutions Ltd']
  spec.email         = ['info@codevise.de']

  spec.summary       = 'Nagios plugin to check Resque queue sizes.'
  spec.homepage      = 'http://github.com/codevise/nagios_check_resque'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'nagios_check', '~> 0.4.0'
  spec.add_dependency 'resque', '~> 1.25'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.6'
end
