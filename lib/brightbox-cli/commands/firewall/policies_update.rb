module Brightbox
  command ["firewall-policies", "firewall-policy"] do |cmd|
    cmd.desc I18n.t("firewall.policies.update.desc")
    cmd.arg_name "firewall-policy-id"
    cmd.command [:update] do |c|
      c.desc I18n.t("options.name.desc")
      c.flag %i[n name]

      c.desc I18n.t("options.description.desc")
      c.flag %i[d description]

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

        model = Fog::Brightbox::Compute::FirewallPolicy.new(data)
        policy = FirewallPolicy.new(model)

        render_table([policy], global_options)
      end
    end
  end
end
