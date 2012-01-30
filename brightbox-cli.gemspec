# -*- encoding: utf-8 -*-
require File.join(File.dirname(__FILE__), "lib/brightbox-cli/version")

Gem::Specification.new do |s|
  s.name        = "brightbox-cli"
  s.version     = Brightbox::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["John Leach"]
  s.email       = ["john@brightbox.co.uk"]
  s.homepage    = "http://docs.brightbox.com/cli"
  s.summary     = %q{The Brightbox cloud management system}
  s.description = %q{Scripts to interact with the Brightbox cloud API}

  s.rubyforge_project = "brightbox-cli"

  s.files         = `git ls-files`.split("\n") + `find lib/brightbox-cli/vendor`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'json', '~> 1.5.3'
  s.add_dependency 'hirb', '0.3.5'
  s.add_dependency 'formatador', '~> 0.2.0'
  s.add_dependency 'excon', '~> 0.6.1'
  s.add_dependency 'builder'
  s.add_dependency 'mime-types'
  s.add_dependency 'net-ssh', '~> 2.2.1'
  s.add_dependency 'net-scp', '~> 1.0.4'
  s.add_dependency 'nokogiri', '~> 1.5.0'
  s.add_dependency 'ruby-hmac'
  s.add_development_dependency('rake', '~> 0.8.0')
  s.add_development_dependency('vcr')
  s.add_development_dependency('rspec')
  s.add_development_dependency('mocha')
end

