module Brightbox
  command [:lbs] do |cmd|
    cmd.desc I18n.t("lbs.create.desc")
    cmd.long_desc I18n.t("lbs.create.long_desc")
    cmd.arg_name "srv-id..."
    cmd.command [:create] do |c|
      c.desc I18n.t("options.name.desc")
      c.flag %i[n name]

      c.desc "Load balancer policy"
      c.default_value "least-connections"
      c.flag %i[p policy]

      c.desc "Listeners. Format: in-port:out-port:type:timeout. Comma separated multiple listeners. Protocols can be tcp, http or http+ws and timeouts are in milliseconds."
      c.default_value "80:80:http:50000,443:443:tcp:50000"
      c.flag %i[l listeners]

      c.desc "Healthcheck port. Defaults to first listener out port."
      c.flag [:k, "hc-port"]

      c.desc "Healthcheck type. Defaults to first listener protocol."
      c.flag [:y, "hc-type"]

      c.desc "Buffer Size. Defaults to 4096 bytes"
      c.flag [:b, "buffer-size"]

      c.desc "Healthcheck timeout"
      c.default_value "5000"
      c.flag [:t, "hc-timeout"]

      c.desc "Healthcheck request. When the type is 'http' this is the url to request."
      c.default_value "/"
      c.flag [:s, "hc-request"]

      c.desc "Health check interval"
      c.default_value "5000"
      c.flag [:e, "hc-interval"]

      c.desc "Health check threshold up. Number of successful health checks for the node to be considered up."
      c.default_value "3"
      c.flag [:u, "hc-up"]

      c.desc "Health check threshold down. Number of failed health checks for the node to be considered down."
      c.default_value "3"
      c.flag [:d, "hc-down"]

      c.desc "ACME domains"
      c.flag ["acme_domains"]

      c.desc "Filepath to the SSL certificate file to use."
      c.flag ["ssl-cert"]

      c.desc "Filepath to the private key used to sign SSL certificate (OpenSSL supported formats)."
      c.flag ["ssl-key"]

      c.desc "Sets the minimum version of TLS/SSL to support in the format 'TLSv1.x'"
      c.default_value "TLSv1.2"
      c.flag ["ssl-min-ver"]

      c.desc "Enable SSL v3 support"
      c.switch ["sslv3"]

      c.action do |global_options, options, args|
        listeners = options[:l].split(",").map do |l|
          inport, outport, protocol, timeout = l.split ":"
          raise "listener '#{l}' is invalid" if inport.nil? || outport.nil? || protocol.nil?

          { :in => inport, :out => outport, :protocol => protocol, :timeout => timeout }
        end

        raise "You must specify at least one listener" if listeners.empty?

        # Setup default healthcheck port if not specified
        if options[:k].nil?
          options[:k] = listeners.first[:out]
        end

        if options[:y].nil?
          options[:y] = listeners.first[:protocol]
        end

        if options[:b]
          options[:b] = options[:b].to_i
        end

        if options["acme_domains"]
          options["acme_domains"] = options["acme_domains"].split(",")
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

        options.each_key do |k|
          if options[k] && hc_arg_lookup[k]
            healthcheck[hc_arg_lookup[k]] = options[k]
          end
        end

        # SSL arguments
        ssl_cert_path = options["ssl-cert"]
        ssl_key_path = options["ssl-key"]

        if ssl_cert_path.nil? ^ ssl_key_path.nil?
          raise "Both SSL arguments (ssl-cert and ssl-key) are required."
        end

        if ssl_cert_path && ssl_key_path
          ssl_cert = File.read(File.expand_path(ssl_cert_path))
          ssl_key = File.read(File.expand_path(ssl_key_path))
        end

        nodes = args.map { |i| { :node => i } }

        msg = "Creating a new load balancer"
        info msg
        lb = LoadBalancer.create(
          domains: options["acme_domains"],
          buffer_size: options[:b],
          certificate_pem: ssl_cert,
          certificate_private_key: ssl_key,
          healthcheck: healthcheck,
          listeners: listeners,
          name: options[:n],
          nodes: nodes,
          policy: options[:policy],
          ssl_minimum_version: options["ssl-min-ver"],
          sslv3: options["sslv3"]
        )
        render_table([lb], global_options)
      end
    end
  end
end
