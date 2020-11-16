module Brightbox
  command [:lbs] do |cmd|

    cmd.desc I18n.t("lbs.update.desc")
    cmd.long_desc I18n.t("lbs.update.long_desc")
    cmd.arg_name "lba-id [node-id...]"
    cmd.command [:update] do |c|

      c.desc I18n.t("options.name.desc")
      c.flag [:n, :name]

      c.desc "Load balancer policy"
      c.flag [:p, :policy]

      c.desc "Listeners (in-port:out-port:protocol:timeout. Comma separate multiple listeners)"
      c.flag [:l, :listeners]

      c.desc "Healthcheck port"
      c.flag [:k, "hc-port"]

      c.desc "Healthcheck type"
      c.flag [:y, "hc-type"]

      c.desc "Buffer Size. Defaults to 4096 bytes"
      c.flag [:b, "buffer-size"]

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

      c.desc "Filepath to the SSL certificate file to use."
      c.flag ["ssl-cert"]

      c.desc "Filepath to the private key used to sign SSL certificate (OpenSSL supported formats)."
      c.flag ["ssl-key"]

      c.desc "Sets the minimum version of TLS/SSL to support in the format 'TLSv1.x'"
      c.flag ["ssl-min-ver"]

      c.desc "Clears SSL details from the load balancer."
      c.switch ["remove-ssl"], :negatable => false

      c.desc "Enable SSL v3 support"
      c.switch ["sslv3"]

      c.action do |global_options, options, args|

        lb_id = args.shift
        raise "You must specify the load balancer to update as the first argument" unless lb_id =~ /^lba-/

        lbopts = NilableHash.new

        unless args.empty?
          lbopts[:nodes] = args.map { |a| { :node => a } }
        end

        hc_arg_lookup = {
          :k => :port,
          :y => :type,
          :t => :timeout,
          :s => :request,
          :e => :interval,
          :u => :threshold_up,
          :d => :threshold_down
        }

        healthcheck = {}

        options.keys.each do |k|
          if options[k] && hc_arg_lookup[k]
            healthcheck[hc_arg_lookup[k]] = options[k]
          end
        end

        unless healthcheck.keys.empty?
          lbopts[:healthcheck] = healthcheck
        end

        if options[:l]
          lbopts[:listeners] = options[:l].split(",").map do |l|
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

        if options[:b]
          lbopts[:buffer_size] = options[:b]
        end

        # SSL argumens
        ssl_cert_path = options["ssl-cert"]
        ssl_key_path = options["ssl-key"]
        remove_ssl = options["remove-ssl"]

        if remove_ssl && (ssl_cert_path || ssl_key_path)
          raise "Cannot set an SSL argument whilst removing the certificate!"
        end

        if ssl_cert_path.nil? ^ ssl_key_path.nil?
          raise "Both SSL arguments (ssl-cert and ssl-key) are required."
        end

        if ssl_cert_path && ssl_key_path
          lbopts[:certificate_pem] = File.read(File.expand_path(ssl_cert_path))
          lbopts[:certificate_private_key] = File.read(File.expand_path(ssl_key_path))
        end

        lbopts[:sslv3] = options["sslv3"] unless options["sslv3"].nil?

        if remove_ssl
          lbopts[:certificate_pem] = ""
          lbopts[:certificate_private_key] = ""
        end

        if options["ssl-min-ver"]
          lbopts[:ssl_minimum_version] = options["ssl-min-ver"] unless options["ssl-min-ver"].nil?
        end

        lbopts.nilify_blanks

        lb = LoadBalancer.find lb_id

        info "Updating load balancer #{lb}"
        lb = lb.update(lbopts)
        render_table([lb], global_options)
      end
    end
  end
end
