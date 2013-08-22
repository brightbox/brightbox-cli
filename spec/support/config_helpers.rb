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

    config
  end
end
