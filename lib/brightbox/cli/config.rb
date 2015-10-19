require "singleton"

module Brightbox
  module CLI
    class Config
      include Singleton

      attr_accessor :config
    end
  end

  def self.config
    CLI::Config.instance.config
  end

  def self.config=(replacement)
    CLI::Config.instance.config = replacement
  end
end
