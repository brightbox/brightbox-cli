module Brightbox
  desc "Lists the type of templates available for servers"
  command [:types] do |cmd|
    cmd.default_command :list

    cmd.desc "List types"
    cmd.arg_name "[type-id...]"
    cmd.command [:list] do |c|
      c.action do |global_options, _options, args|
        types = if args.empty?
                  Type.find :all
                else
                  Type.find_or_call(args) do |id|
                    warn "Couldn't find type #{id}"
                  end
                end

        render_table(types.sort, global_options)
      end
    end

    cmd.desc "Show detailed type info"
    cmd.arg_name "type-id..."
    cmd.command [:show] do |c|
      c.action do |global_options, _options, args|
        if args.empty?
          raise "You must specify the types you want to show"
        end

        types = Type.find_or_call(args) do |id|
          warn "Couldn't find type #{id}"
        end

        display_options = {
          :vertical => true,
          :fields => %i[id handle status name ram disk cores]
        }

        table_opts = global_options.merge(display_options)
        render_table(types, table_opts)
      end
    end
  end
end
