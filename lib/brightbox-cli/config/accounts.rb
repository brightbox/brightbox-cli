module Brightbox
  module Config
    module Accounts
      def save_default_account(account_id)
        dirty! unless account_id == selected_config["default_account"]

        selected_config["default_account"] = account_id
      end

      def default_account
        return unless selected_config

        configured_default_account = selected_config["default_account"]
        return configured_default_account if configured_default_account && !configured_default_account.empty?
      end

      def determine_account(preferred_account)
        return preferred_account if preferred_account
        return config[client_name]["default_account"] unless client_name.nil?
      end

      def account
        if defined?(@account) && @account
          @account
        else
          default_account
        end
      end

      # If a client does not have a default account, this will attempt to set it
      # if there is one.
      #
      # @note This queries the API whenever a default is not set so creates
      #   excess traffic for certain use cases on all commands.
      #
      def find_or_set_default_account
        # FIXME: API clients are scoped to their account so this code should
        #   never need to run for them.
        return if default_account

        begin
          service = Fog::Compute.new(to_fog)
          accounts = service.accounts

          @account = accounts.select { |acc| %w[pending active].include?(acc.status) }.first.id
          save_default_account(@account) if @account
        rescue Brightbox::BBConfigError
          # We can't get a suitable fog connection so we can't select an
          # account
        rescue Excon::Errors::Unauthorized
          # This is a helper, if it fails let the other code warn and prompt
        end
      end
    end
  end
end
