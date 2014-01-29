module Brightbox
  command [:"firewall-policies"] do |cmd|

    cmd.desc "Update a firewall policy"
    cmd.arg_name "firewall-policy-id"
    cmd.command [:update] do |c|

      c.desc "Name of policy"
      c.flag [:n, :name]

      c.desc "Description of policy"
      c.flag [:d, :description]

      c.action do |global_options, options, args|
        policy_id = args.shift
        raise "You must specify the firewall-policy-id to update" if policy_id.nil?

        params = NilableHash.new

        if options[:n]
          params[:name] = options[:n]
        end

        if options[:d]
          params[:description] = options[:d]
        end

        params.nilify_blanks

        if params.empty?
          raise "No options were given so unable to update"
        end

        info "Updating policy #{policy_id}"
        # FirewallPolicy fog model does not currently include update so done
        # with a request, before updating the model
        data = FirewallPolicy.conn.update_firewall_policy(policy_id, params)

        model = Fog::Compute::Brightbox::FirewallPolicy.new(data)
        policy = FirewallPolicy.new(model)

        render_table([policy], global_options)
      end
    end
  end
end
