require 'bundler'
Bundler::GemHelper.install_tasks

bbcloud_path = File.expand_path('./lib', File.dirname(__FILE__))
$:.unshift(bbcloud_path)
require "brightbox-cli/command_generator"

desc "generate brightbox-commands"
task :generate_commands do
  Brightbox::CommandGenerator.new(bbcloud_path)
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

task :default => [:spec]
