module Brightbox
  desc 'Destroy Firewall Policy'
  arg_name '[firewall-policy-id...]'
  command [:destroy] do |c|
    c.action do |global_options, options, args|

      raise "You must specify firewall-policy-id to destroy" if args.empty?
      firewall_policy_id = args.shift

      firewall_policy = FirewallPolicy.find(firewall_policy_id) do |id|
        raise "Couldn't find Firewall Policy #{id}"
      end

      info "Destroying firewall policy #{firewall_policy}"
      begin
        firewall_policy.destroy
      rescue Brightbox::Api::Conflict => e
        error "Could not destroy #{firewall_policy}"
      end

    end
  end
end
