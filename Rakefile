require "bundler"
require "rspec/core/rake_task"

bbcloud_path = File.expand_path("./lib", File.dirname(__FILE__))
$LOAD_PATH.unshift(bbcloud_path)

task :default => [:test]

Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new

desc "Runs all tests (rspec and cucumber)"
task :test do
  Rake::Task["spec"].invoke
end
