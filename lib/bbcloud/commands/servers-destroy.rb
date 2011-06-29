module Brightbox
  desc 'Destroy servers'
  arg_name '[server-id...]'
  command [:destroy] do |c|
    c.action do |global_options, options, args|

      raise "You must specify servers to destroy" if args.empty?

      servers = Server.find_or_call(args) do |id|
        raise "Couldn't find server #{id}"
      end

      servers.each do |server|
        info "Destroying server #{server}"
        begin
          server.destroy
        rescue Brightbox::Api::Conflict => e
          error "Could not destroy #{server}"
        end
      end

    end
  end
end
