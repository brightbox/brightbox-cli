module Brightbox
  class Account < Api
    def ram_free
      [ram_limit.to_i - ram_used.to_i, 0].max
    end

    def cloud_ip_limit
      attributes[:cloud_ips_limit]
    end

    def lb_limit
      attributes[:load_balancers_limit]
    end

    def to_row
      attributes.merge(:ram_free => ram_free, :cloud_ip_limit => cloud_ip_limit, :lb_limit => lb_limit)
    end

    def self.all
      if Brightbox.config.using_application?
        conn.accounts.all
      else
        [conn.account]
      end
    end

    def self.get(id)
      a = if Brightbox.config.using_application?
            conn.accounts.get(id)
          else
            conn.account
          end

      if a && a.id == id
        a
      end
    end

    def self.default_field_order
      %i[id name cloud_ips_limit lb_limit ram_limit ram_used ram_free]
    end

    def to_s
      @id
    end
  end
end
