desc 'List types'
arg_name '[type-id...]'
command [:list] do |c|
  c.action do |global_options,options,args|

    if args.empty?
      raise "You must specify the types you want to show"
    end

    types = Type.find_or_call(args) do |id|
      warn "Couldn't find type #{id}"
    end

    render_table(types, global_options)
  end
end
