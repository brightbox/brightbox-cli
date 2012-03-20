module Brightbox
  desc 'Update a load balancer'
  long_desc "All intervals and timeouts are in milliseconds"
  arg_name 'lba-id [node-id...]'

  command [:update] do |c|

    c.desc "Friendly name of load balancer"
    c.flag [:n, :name]

    c.desc "Load balancer policy"
    c.flag [:p, :policy]

    c.desc "Listeners (in-port:out-port:protocol:timeout. Comma separate multiple listeners)"
    c.flag [:l, :listeners]

    c.desc "Healthcheck port"
    c.flag [:k, "hc-port"]

    c.desc "Healthcheck type"
    c.flag [:y, "hc-type"]

    c.desc "Healthcheck timeout"
    c.flag [:t, "hc-timeout"]

    c.desc "Healthcheck request. When the type is 'http' this is the url to request."
    c.flag [:s, "hc-request"]

    c.desc "Healthcheck interval"
    c.flag [:e, "hc-interval"]

    c.desc "Healthcheck threshold up. Number of successful healthchecks for the node to be considered up."
    c.flag [:u, "hc-up"]

    c.desc "Healthcheck threshold down. Number of failed healthchecks for the node to be considered down."
    c.flag [:d, "hc-down"]

    c.action do |global_options, options, args|

      lb_id = args.shift
      raise "You must specify the load balancer to update as the first argument" unless lb_id =~ /^lba-/

      lbopts = NilableHash.new

      unless args.empty?
        lbopts[:nodes] = args.collect { |a| { :node => a } }
      end

      hc_arg_lookup = { :k => :port, :y => :type, :t => :timeout, :s =>
        :request, :e => :interval, :u => :threshold_up, :d =>
        :threshold_down }

      healthcheck = {}

      options.keys.each do |k|
        if options[k] and hc_arg_lookup[k]
          healthcheck[hc_arg_lookup[k]] = options[k]
        end
      end

      unless healthcheck.keys.empty?
        lbopts[:healthcheck] = healthcheck
      end

      if options[:l]
        lbopts[:listeners] = options[:l].split(",").collect do |l|
          inport, output, protocol, timeout = l.split ":"
          { :in => inport, :out => output, :protocol => protocol, :timeout => timeout }
        end
      end

      if options[:n]
        lbopts[:name] = options[:n]
      end

      if options[:p]
        lbopts[:policy] = options[:p]
      end

      lbopts.nilify_blanks

      lb = LoadBalancer.find lb_id

      info "Updating load balancer #{lb}"
      lb = lb.update(lbopts)
      render_table([lb], global_options)
    end
  end
end
