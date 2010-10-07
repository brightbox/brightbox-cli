desc 'List types'
arg_name '[type-id...]'
command [:list] do |c|
  c.action do |global_options,options,args|

    types = Type.find args, :order => :ram

    render_table(types, global_options)
  end
end
