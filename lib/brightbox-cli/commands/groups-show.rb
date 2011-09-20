module Brightbox
  desc 'Update a server group'
  arg_name 'grp-id'
  command [:show] do |c|
    c.action do |global_options, options, args|
      raise "You must specify server groups to show" if args.empty?

      sgs = ServerGroup.find_or_call(args) do |id|
        raise "Couldn't find server group #{id}"
      end

      table_opts = global_options.merge({
        :vertical => true,
        :fields => [:id, :name, :description, "servers"]
      })
      render_table(sgs, table_opts)
    end
  end
end
