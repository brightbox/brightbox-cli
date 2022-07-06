require "tmpdir"
require "fileutils"

# This class encapsulates the pattern of creating a temporary configuration file
# from a String, easiliy referencing the directory to initialise a BBConfig and
# dispose of
#
class TmpConfig
  attr_reader :path

  # Creates a temporary directory and a "config" file within using the contents
  # of a passed String.
  #
  # Recommended to use {#close} to delete
  #
  # @param [String] contents
  #
  def initialize(contents)
    @path = Dir.mktmpdir
    @file = File.open(File.join(@path, "config"), "w+")
    @file.write(contents)
    @file.close
    self
  end

  def close
    FileUtils.remove_entry_secure(path)
  end
end
