require "fileutils"
require "securerandom"

module ConfigHelpers
  # Returns a Brightbox::BBConfig based on the String as its contents
  #
  # It's like a fake configuration - IN A CAN!
  #
  def config_from_contents(contents)
    # Create it (with a non existing file)
    config = Brightbox::BBConfig.new

    # Load the contents into the expected location
    FileUtils.mkdir_p config.config_directory
    File.open(config.config_filename, "w") do |f|
      f.write contents
    end

    # Subvert the global
    Brightbox.config = config

    config
  end

  def remove_config
    config = Brightbox::BBConfig.new
    FileUtils.rm_rf config.config_filename
  end

  # Returns the file contents of a config
  #
  def config_file_contents
    config = Brightbox::BBConfig.new
    IO.read(config.config_filename)
  end
end
