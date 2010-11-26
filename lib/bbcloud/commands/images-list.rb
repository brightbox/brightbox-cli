desc 'List available images'
arg_name '[image-id...]'
command [:list] do |c|
  c.action do |global_options, options, args|

    if args.empty?
      images = Image.find(:all)
    else
      images = Image.find_or_call(args) do |id|
        warn "Couldn't find image #{id}"
      end
    end

    snapshots = images.select { |i| i.source_type == 'snapshot' }

    images = images - snapshots

    images.sort! do |a,b|
      [a.official ? 0 : 1, a.name, a.arch] <=> [b.official ? 0 : 1, b.name, b.arch]
    end

    snapshots.sort! { |a, b| a.created_at <=> b.created_at }
    
    render_table(images + snapshots, global_options)
  end
end
