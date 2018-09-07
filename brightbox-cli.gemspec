# -*- encoding: utf-8 -*-
require File.join(File.dirname(__FILE__), "lib/brightbox-cli/version")

Gem::Specification.new do |s|
  s.name        = "brightbox-cli"
  s.version     = Brightbox::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["John Leach"]
  s.email       = ["john@brightbox.co.uk"]
  s.homepage    = "http://docs.brightbox.com/cli"
  s.summary     = %q(The Brightbox cloud management system)
  s.description = %q(Scripts to interact with the Brightbox cloud API)
  s.license     = "MIT"

  s.required_ruby_version = ">= 1.9.3"

  s.rubyforge_project = "brightbox-cli"

  s.files         = `git ls-files`.split("\n") + `find lib/brightbox-cli/vendor`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "fog-brightbox", ">= 0.16.0", "< 1.0"
  s.add_dependency "fog-core", "< 2.0"
  s.add_dependency "gli", "~> 2.12.0"
  s.add_dependency "i18n", "~> 0.6.0"
  s.add_dependency "mime-types", "~> 2.6"
  s.add_dependency "multi_json", "~> 1.11.0"
  s.add_dependency "highline", "~> 1.6.0"
  s.add_dependency "hirb", "~> 0.6"

  s.add_development_dependency "mocha"
  s.add_development_dependency "pry-remote"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", "~> 2.99"
  s.add_development_dependency "vcr", "~> 2.5"
  s.add_development_dependency "webmock"

  s.post_install_message = <<-EOS
The CLI command is now `brightbox` with subcommands for the resources.
Such as `brightbox config` or `brightbox servers`.

  `brightbox --help` lists all the commands.

The old hypenated versions of the commands (e.g. `brightbox-servers`)
are deprecated and may be removed in the future.

If you have been using the old "brightbox" gem please ensure you have
the latest version to be able to use the `brightbox-capify` command.

To enable Bash auto-completion you can do the following:

  complete -C _brightbox-bash-completer -o filenames brightbox

EOS
end
