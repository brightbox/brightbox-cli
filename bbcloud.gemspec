# -*- encoding: utf-8 -*-
require File.join(File.dirname(__FILE__), "lib/bbcloud/version")

Gem::Specification.new do |s|
  s.name        = "bbcloud"
  s.version     = Brightbox::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["John Leach"]
  s.email       = ["john@brightbox.co.uk"]
  s.homepage    = "http://docs.brightbox.com/cli"
  s.summary     = %q{The Brightbox cloud management system}
  s.description = %q{Scripts to interact with the Brightbox cloud API}

  s.rubyforge_project = "bbcloud"

  s.files         = `git ls-files`.split("\n") + `find lib/bbcloud/vendor`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.post_install_message = %q{
********** You are running/updating deprecated bbcloud gem ***********************
To get the updated version, please run gem install brightbox-cli
**********************************************************************************
}

  s.add_dependency 'json', '~> 1.5.3'
  s.add_dependency 'hirb', '0.3.5'
  s.add_dependency 'formatador', '~> 0.1.4'
  s.add_dependency 'excon', '~> 0.6.1'
  s.add_dependency 'fog', '~> 0.8.0'
  s.add_development_dependency('rake', '~> 0.8.0')
  s.add_development_dependency('vcr')
  s.add_development_dependency('rspec')
  s.add_development_dependency('mocha')
end

