module Brightbox
  class CloudIP < Api
    def self.get id
      conn.cloud_ips.get id
    end

    def self.all
      conn.cloud_ips
    end

    def self.create(options = {})
      create_options = {}
      if options[:t]
        create_options[:port_translators] = format_translators_for_api(options[:t])
      end

      if options[:n] && !options[:name].empty?
        create_options[:name] = options[:n]
      end
      r = conn.create_cloud_ip(create_options)
      new(r["id"])
    end

    def self.format_translators_for_api(translators)
      translators.split(",").map do |t|
        incoming,outgoing,protocol = t.split(":")
        raise "translator #{t} is invalid" if incoming.nil? || outgoing.nil? || protocol.nil?
        {:incoming => incoming, :outgoing => outgoing, :protocol => protocol}
      end
    end

    def attributes
      a = fog_model.attributes
      if(lb_id = a[:load_balancer] || a["load_balancer"])
        a[:destination] = lb_id
      elsif(server_group_id = a[:server_group] || a["server_group"])
        a[:destination] = server_group
      else
        a[:destination] = a[:server_id]
      end
      a
    end

    def to_row
      o = attributes
      o[:port_translators] = translators(o)
      o
    end

    def mapped?
      status == 'mapped'
    end

    def translators(raw_attributes)
      if translators = (raw_attributes[:port_translators] || raw_attributes['port_translators'])
        translators.map {|t| [t['incoming'],t['outgoing'],t['protocol']].join(":") }
      else
        nil
      end
    end

    def self.default_field_order
      [:id, :status, :public_ip, :destination, :reverse_dns, :name]
    end

    def <=>(b)
      self.status <=> b.status
    end

    def update(options)
      params = {}
      if options[:r]
        params[:reverse_dns] = options[:r]
      end

      if options[:"delete-reverse-dns"]
        params[:reverse_dns] = ""
      end

      if options[:n] && !options[:name].empty?
        params[:name] = options[:n]
      end

      if options[:t]
        params[:port_translators] = CloudIP.format_translators_for_api(options[:t])
      end

      self.class.conn.update_cloud_ip(id, params)
      self.reload
      self
    end

  end
end
