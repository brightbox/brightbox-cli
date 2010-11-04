desc 'Restart the specified servers'
arg_name 'server-id...'
command [:restart] do |c|
  c.desc "Soft restart (default)"
  c.switch [:s, "soft"]

  c.desc "Hard restart"
  c.default_value true
  c.switch [:d, "hard"]

  c.action do |global_options,options,args|

    if options[:soft] and options[:hard]
      raise "Cannot do both hard and soft restart at the same time"
    end

    type = options[:hard] ? "hard" : "soft"

    servers = Server.find(args).compact

    servers.each do |s|
      info "Restarting server #{s}"
      s.reboot(type)
      s.reload
    end

    render_table(servers)

  end
end
