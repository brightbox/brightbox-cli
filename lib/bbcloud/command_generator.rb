module Brightbox
  class CommandGenerator
    COMMAND_LIST = [
      'brightbox-accounts',
      'brightbox-cloudips',
      'brightbox-config',
      'brightbox-images',
      'brightbox-lbs',
      'brightbox-servers',
      'brightbox-types',
      'brightbox-users',
      'brightbox-zones'
    ]

    def initialize(bbcloud_path)
      @bbcloud_path = bbcloud_path
      COMMAND_LIST.each do |command|
        File.open("#{cli_binary_path}/#{command}","w+") do |fl|
          fl.write(command_template)
        end
      end
    end

    private
    def command_template
      brightbox_command =<<-EOF
#!/usr/bin/env ruby

begin
  require "bbcloud"
rescue LoadError
  bbcloud_path = File.expand_path('../../lib', __FILE__)
  $:.unshift(bbcloud_path)
  require "bbcloud"
end

Brightbox::BBConfig.config do
  include GLI
  run ARGV
end
      EOF
      brightbox_command
    end

    def cli_binary_path
      File.join(@bbcloud_path,"..","bin")
    end
    
  end
end