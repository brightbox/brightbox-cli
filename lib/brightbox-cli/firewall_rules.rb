module Brightbox
  class FirewallRules
    def self.from_policy(firewall_policy)
      rules = firewall_policy.rules
      rules.map do |rule|
        fwr = FirewallRule.new('fwr')
        fwr.attributes = symbolize_keys(rule)
        fwr
      end
    end

    def self.symbolize_keys(object) #:nodoc:
      modify_keys(object) do |key|
        key.is_a?(String) ? key.to_sym : key
      end
    end

    def self.modify_keys(object, &modifier) #:nodoc:
      object.inject({}) do |result, (key, value)|
        new_key   = modifier.call(key)
        result.merge! new_key => value
      end
    end

  end
end
