module Brightbox
  # A Collaborating account combines all of a users own accounts and those that
  # they have access to via an open collaboration.
  #
  class CollaboratingAccount < Account
    def self.all
      accounts = conn.accounts.all
      collaborations = conn.user_collaborations.all

      accepted_collaborations = collaborations.select do |col|
        col.status == "accepted"
      end

      pending_collaborations = collaborations.select do |col|
        col.status == "pending"
      end

      col_accounts = []

      accepted_collaboration_ids = accepted_collaborations.map(&:account_id)
      accounts.each do |acc|
        if accepted_collaboration_ids.include?(acc.id)
          collab = accepted_collaborations.find { |col| col.account_id == acc.id }
          col_accounts << new(acc, collab)
        else
          col_accounts << new(acc)
        end
      end

      pending_collaborations.each do |col|
        col_accounts << new(col)
      end

      col_accounts
    end

    # Simpler initialiser than the superclass.
    #
    # @param [Account,UserCollaboration] fog_model The source data
    # @param [UserCollaboration] collaboration_status The state of the collaboration passed
    #   in for accounts/collaborations
    #
    def initialize(fog_model, collaboration = nil)
      @fog_model = fog_model
      @id = fog_model.id
      # Rather than merging, we have store the collaboration as a secondary item
      @collaboration = collaboration
      if @collaboration.nil? && @fog_model.attributes["resource_type"] == "collaboration"
        @collaboration = @fog_model
      end
    end

    # Is this record based on an account?
    def account?
      resource_type == "account"
    end

    # Is this record based on a collaboration?
    def collaboration?
      resource_type == "collaboration"
    end

    def resource_type
      attributes[:resource_type] || attributes["resource_type"]
    end

    def id
      if collaboration?
        account_id
      else
        @id
      end
    end

    def name
      account? ? fog_model.name : acc_details(:name)
    end

    def cloud_ips_limit
      account? ? attributes[:cloud_ips_limit] : ""
    end

    def lb_limit
      account? ? attributes[:load_balancers_limit] : ""
    end

    def ram_limit
      account? ? attributes[:ram_limit] : ""
    end

    def ram_used
      account? ? attributes[:ram_used] : ""
    end

    def ram_free
      if account?
        [ram_limit.to_i - ram_used.to_i, 0].max
      else
        ""
      end
    end

    # The "role" between the requesting user and the account
    #
    # It is either "owner", "collaborator" or "(invited)"
    #
    # You'd think it would be somehow related to the role but no.
    #
    def role
      if @collaboration
        if @collaboration.attributes[:status] == "accepted"
          "collaborator"
        else
          "(invited)"
        end
      else
        "owner"
      end
    end

    def to_row
      {
        :id => id,
        :cloud_ips_limit => cloud_ips_limit,
        :lb_limit => lb_limit,
        :ram_limit => ram_limit,
        :ram_used => ram_used,
        :ram_free => ram_free,
        :role => role,
        :name => name
      }
    end

    def self.default_field_order
      %i[id cloud_ips_limit lb_limit ram_limit ram_used ram_free role name]
    end

    private

    # A collaboration has access to the accounts details by nesting
    def acc_details(key)
      # Underlying fog setup means you use [:account]["key"] but this helps
      attributes[:account][key.to_s]
    end
  end
end
