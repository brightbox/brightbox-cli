module Brightbox
  class CommandGenerator
    COMMAND_LIST = [
      'brightbox-accounts',
      'brightbox-cloudips',
      'brightbox-config',
      'brightbox-groups',
      'brightbox-images',
      'brightbox-lbs',
      'brightbox-servers',
      'brightbox-firewall-policies',
      'brightbox-firewall-rules',
      'brightbox-types',
      'brightbox-users',
      'brightbox-zones'
    ]

    def initialize(brightbox_cli_path)
      @brightbox_cli_path = brightbox_cli_path
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
  require "brightbox_cli"
rescue LoadError
  brightbox_cli_path = File.expand_path('../../lib', __FILE__)
  $:.unshift(brightbox_cli_path)
  require "brightbox_cli"
end

Brightbox::BBConfig.config do
  include GLI
  run ARGV
end
      EOF
      brightbox_command
    end

    def cli_binary_path
      File.join(@brightbox_cli_path,"..","bin")
    end

  end
end
