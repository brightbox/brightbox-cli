module Brightbox
  desc 'update Cloud IPs'
  arg_name 'cloudip-id'
  command [:update] do |c|
    c.desc "Set reverse DNS for this cloud ip"
    c.flag [:r, "reverse-dns"]

    c.desc "Delete the reverse dns for this cloud ip"
    c.switch ["delete-reverse-dns"]

    c.action do |global_options,options,args|
      cip_id = args.shift
      raise "You must specify the cloud ip id as the first argument" unless cip_id =~ /^cip-/

      if options[:r] && options[:r] != "" && options[:"delete-reverse-dns"]
        raise "You must either specify a reverse dns record or --delete-reverse-dns"
      end

      cip = CloudIP.find cip_id

      params = {}
      if options[:r]
        params[:reverse_dns] = options[:r]
      end

      if options[:"delete-reverse-dns"]
        params[:reverse_dns] = ""
      end

      cip.update(params)
      cip.reload

      render_table([cip], global_options)
    end
  end
end
