require "bundler"
require "rspec/core/rake_task"
require "brightbox-cli/command_generator"

bbcloud_path = File.expand_path("./lib", File.dirname(__FILE__))
$:.unshift(bbcloud_path)

task :default => [:test]

Bundler::GemHelper.install_tasks

desc "generate brightbox-commands"
task :generate_commands do
  Brightbox::CommandGenerator.new(bbcloud_path)
end

RSpec::Core::RakeTask.new

desc "Runs all tests (rspec and cucumber)"
task :test do
  Rake::Task["spec"].invoke
end
