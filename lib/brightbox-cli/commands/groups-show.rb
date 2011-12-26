module Brightbox
  desc 'Show detailed server group info'
  arg_name '[grp-id..]'
  command [:show] do |c|
    c.action do |global_options, options, args|
      raise "You must specify server groups to show" if args.empty?

      sgs = DetailedServerGroup.find_or_call(args) do |id|
        raise "Couldn't find server group #{id}"
      end
      render_table(sgs, global_options.merge(:vertical => true))
    end
  end
end
