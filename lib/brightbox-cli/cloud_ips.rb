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
      translators(options[:t],create_options)
      name(options[:n],create_options)
      r = conn.create_cloud_ip(create_options)
      new(r["id"])
    end

    def self.translators(translators,options)
      if translators && !translators.empty?
        options[:port_translators] = translators.split(",").map do |t|
          incoming,outgoing,protocol = t.split(":")
          raise "translator #{t} is invalid" if incoming.nil? || outgoing.nil? || protocol.nil?
          {:incoming => incoming, :outgoing => outgoing, :protocol => protocol}
        end
      end
    end

    def self.name(name,options)
      if name && !name.empty?
        options[:name] = name
      end
    end

    def attributes
      a = fog_model.attributes
      add_name_to_dns(a)
      if(lb_id = a[:load_balancer] || a["load_balancer"])
        a[:destination] = lb_id
      else
        a[:destination] = a[:server_id]
      end
      a
    end

    def add_name_to_dns(raw_attributes)
      reverse_dns = raw_attributes[:reverse_dns] || raw_attributes['reverse_dns']
      if name = (raw_attributes[:name] || raw_attributes['name'])
        raw_attributes[:reverse_dns] = "#{name} (#{reverse_dns})"
      end
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
      [:id, :status, :public_ip, :destination, :reverse_dns]
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


      CloudIP.name(options[:n],params)
      CloudIP.translators(options[:t],params)

      self.class.conn.update_cloud_ip(id, params)
      self.reload
      self
    end

  end
end
