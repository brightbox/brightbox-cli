module Brightbox
  module Config
    module Accounts

      def save_default_account(account_id)
        selected_config['default_account'] = account_id
      end

      #
      #
      #
      def default_account
        configured_default_account = selected_config["default_account"]
        if configured_default_account && !configured_default_account.empty?
          configured_default_account
        else
          nil
        end
      end

      def account
        return @account if defined?(@account) && @account
        find_or_set_default_account
        default_account = selected_config['default_account']
        unless default_account
          raise BBConfigError, "You must specify account to be used with --account option or set default account to use"
        end
        default_account
      end

      # If a client does not have a default account, this will attempt to set it
      # if there is one.
      #
      # @note This queries the API whenever a default is not set so creates
      #   excess traffic for certain use cases on all commands.
      #
      def find_or_set_default_account
        # FIXME API clients are scoped to their account so this code should
        #   never need to run for them.
        unless default_account
          accounts = Account.all
          if accounts.size == 1
            @account = accounts.first.id
            selected_config['default_account'] = @account
          end
        end
      end
    end
  end
end