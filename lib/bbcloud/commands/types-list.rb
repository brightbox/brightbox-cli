desc 'List types'
arg_name '[type-id...]'
command [:list] do |c|
  c.action do |global_options,options,args|

    if args.empty?
      types = Type.find :all
    else
      types = Type.find_or_call(args) do |id|
        warn "Couldn't find type #{id}"
      end
    end

    render_table(types.sort, global_options)
  end
end
