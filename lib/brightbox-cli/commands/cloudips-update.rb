module Brightbox
  desc 'update Cloud IPs'
  arg_name 'cloudip-id'
  command [:update] do |c|
    c.desc "Set reverse DNS for this Cloud IP"
    c.flag [:r, "reverse-dns"]

    c.desc "Delete the reverse DNS for this Cloud IP"
    c.switch ["delete-reverse-dns"]

    c.desc "Friendly name of the Cloud IP"
    c.flag [:n, :name]

    c.desc "Cloud IP translators. Format: in-port:out-port:protocol. Comma separate multiple translators. Protocol can be tcp or udp."
    c.flag [:t, :'port-translators']

    c.action do |global_options,options,args|
      cip_id = args.shift
      raise "You must specify the Cloud IP id as the first argument" unless cip_id =~ /^cip-/

      if options[:r] && options[:r] != "" && options[:"delete-reverse-dns"]
        raise "You must either specify a reverse DNS record or --delete-reverse-dns"
      end

      cip = CloudIP.find cip_id


      cip.update(options)
      cip.reload

      render_table([cip], global_options)
    end
  end
end
