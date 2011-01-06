desc 'Create a load balancer'
arg_name 'srv-id...'
command [:create] do |c|

  c.desc "Friendly name of load balancer"
  c.flag [:n, :name]

  c.desc "Load balancer policy"
  c.default_value "least-connections"
  c.flag [:p, :policy]

  c.desc "Healthcheck"
  c.default_value "80:http"
  c.flag [:k, "health-check"]

  c.desc "Listeners"
  c.default_value "80:80:http,443:443:tcp"
  c.flag [:l, :listeners]

  c.action do |global_options, options, args|

    raise "You must specify which servers to balance connections to" if args.empty?

    listeners = options[:l].split(",").collect do |l|
      inport, output, protocol = l.split ":"
      { :in => inport, :out => output, :protocol => protocol }
    end

    hport, htype = options[:k].split(":")
    healthcheck = { :port => hport, :type => htype }

    nodes = args.collect { |i| { :node => i } }

    msg = "Creating a load balancer"
    info msg
    lb = LoadBalancer.create(:policy => options[:policy],
                        :name => options[:n],
                        :healthcheck => healthcheck,
                        :listeners => listeners,
                        :nodes => nodes)
    render_table([lb], global_options)
  end
end
