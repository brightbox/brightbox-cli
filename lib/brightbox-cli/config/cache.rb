module Brightbox
  module Config
    module Cache
      def cache_path
        if @cache_path
          @cache_path
        else
          @cache_path = File.join(dir, 'cache')
          unless File.exists? @cache_path
            begin
              FileUtils.mkdir @cache_path
            rescue Errno::EEXIST
            end
          end
          @cache_path
        end
      end

      def save!(options = {})
        unless options.empty?
          fetch_refresh_token(options)
        end
        write_config_file
      end

      def save_default_account(account_id)
        selected_config['default_account'] = account_id
        save!
      end

      def save_refresh_token
        if Api.conn.refresh_token && !Api.conn.refresh_token.empty?
          selected_config['refresh_token'] = Api.conn.refresh_token
          save!
        end
      end

      def update_refresh_token
        return false unless using_application?
        highline = HighLine.new()
        highline.say("Your API credentials have expired, enter your password to update them.")
        password = highline.ask("Enter your password : ") { |q| q.echo = false }
        fetch_refresh_token(:client_id => client_name, :email => selected_config['email'], :password => password)
        save!
        highline.say("Your API credentials have been updated, please re-run your command.")
        true
      end

      def fetch_refresh_token(options)
        self.client_name = options[:client_id]
        client_config = config[client_name]
        user_application = Brightbox::Config::UserApplication.new(client_config, client_name)
        # replace this portion with code that actually fetches a token
        client_config['refresh_token'] = user_application.fetch_refresh_token(options)
      end

      def write_config_file
        if @config.is_a? Ini
          @config.write
        end
      end

      def cache_id(cid)
        FileUtils.touch(File.join(cache_path, cid)) unless cid.nil?
      end

    end
  end
end
