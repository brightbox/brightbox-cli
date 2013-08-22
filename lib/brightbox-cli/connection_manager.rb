module Brightbox
  class ConnectionManager

    def initialize(connection_options)
      @connection_options = connection_options
      @connection = nil
    end

    def fetch_connection(account_flag = false)
      if account_flag
        connection_with_account
      else
        @connection ||= create_connection
      end
    end

  private

    def connection_with_account
      if @connection
        @connection.scoped_account = $config.account
        @connection
      else
        selected_account = $config.account
        @connection = create_connection(:brightbox_account => selected_account)
      end
    end

    def connection_options
      merged_options = @connection_options.dup
      if @connection && @connection.refresh_token
        merged_options.update(:brightbox_refresh_token => @connection.refresh_token)
      end

      if @connection && @connection.access_token
        merged_options.update(:brightbox_access_token => @connection.access_token)
      end
      merged_options
    end

    def create_connection(options = {})
      Fog::Compute.new(connection_options.merge(options))
    end
  end
end
