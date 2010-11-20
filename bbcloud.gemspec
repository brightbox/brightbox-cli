# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bbcloud/version"

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

	s.add_dependency 'gli', '1.1.2'
	s.add_dependency 'hirb', '0.3.5'
	s.add_dependency 'fog', '=0.3.23'
	s.add_dependency 'excon', '>=0.2.4'
	s.add_dependency 'ini', '0.1.1'
end
