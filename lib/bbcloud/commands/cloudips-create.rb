desc 'Create a new cloud ip'
command [:create] do |c|
  c.desc "Number of cloud ips to create"
  c.default_value 1
  c.flag [:i, "count"]

  c.action do |global_options, options, args|

    if options[:i].to_s !~ /^[0-9]+$/
      raise "count must be a number"
    end

    options[:i] = options[:i].to_i

    ips = []
    options[:i].times do
      ips << CloudIP.create
    end
    render_table(ips, global_options)
  end
end
