require "aruba/cucumber"
require "excon"

ENV["PATH"] = "#{File.expand_path(File.dirname(__FILE__) + "/../../bin")}#{File::PATH_SEPARATOR}#{ENV["PATH"]}"
LIB_DIR = File.join(File.expand_path(File.dirname(__FILE__)),"..","..","lib")

Before do
  # Using "announce" causes massive warnings on 1.9.2
  @puts = true
  @original_rubylib = ENV["RUBYLIB"]
  ENV["RUBYLIB"] = LIB_DIR + File::PATH_SEPARATOR + ENV["RUBYLIB"].to_s

  # Give commands a bit more breathing space before fail them
  @aruba_timeout_seconds = 7
end

After do
  ENV["RUBYLIB"] = @original_rubylib
end
