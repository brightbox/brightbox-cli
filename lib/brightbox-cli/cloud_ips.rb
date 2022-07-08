module Brightbox
  class CloudIP < Api
    def self.require_account?; true; end

    def self.get(id)
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
        incoming, outgoing, protocol = t.split(":")
        raise "translator #{t} is invalid" if incoming.nil? || outgoing.nil? || protocol.nil?

        { :incoming => incoming, :outgoing => outgoing, :protocol => protocol }
      end
    end

    def attributes
      a = fog_model.attributes
      a[:destination] = destination_id
      a
    end

    def to_row
      o = attributes
      o[:port_translators] = translators(o)
      o
    end

    def mapped?
      status == "mapped"
    end

    def translators(raw_attributes)
      translators = (raw_attributes[:port_translators] || raw_attributes["port_translators"])
      return unless translators

      translators.map do |t|
        [t["incoming"], t["outgoing"], t["protocol"]].join(":")
      end
    end

    def self.default_field_order
      %i[id status public_ip destination reverse_dns name]
    end

    def <=>(other)
      status <=> other.status
    end

    def update(options)
      params = {}
      if options[:r]
        params[:reverse_dns] = options[:r]
      end

      if options[:"delete-reverse-dns"]
        params[:reverse_dns] = ""
      end

      if options[:n] && !options[:n].nil?
        params[:name] = options[:n]
      end

      if options[:t]
        params[:port_translators] = CloudIP.format_translators_for_api(options[:t])
      end

      self.class.conn.update_cloud_ip(id, params)
      reload
      self
    end
  end
end
