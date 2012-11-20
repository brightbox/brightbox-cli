module Brightbox::TestSupport
  class TokenRequester
    include Fog::Brightbox::OAuth2
  end
end

Shindo.tests("Fog::Brightbox::OAuth2 requests", ["brightbox"]) do
  subject = Brightbox::TestSupport::TokenRequester

  # Set the brightbox credentials to instance variables to access easier
  Fog.credentials.each do |key,value|
    instance_variable_set(key.to_s.sub("brightbox_", "@").to_sym, value)
  end

  # Live tests can not be run for both account clients and user apps at
  # the same time because `client_id` is the same key but treatedly
  # different by the server. User apps must supply username and either
  # password or a refresh token to work
  #
  # So we have to guard with this...
  client_id_matches_user_account = @client_id.match(/^app-/)

  authentication_endpoint = @auth_url || "https://api.gb1.brightbox.com/"
  @connection = Fog::Connection.new(authentication_endpoint)

  tests("when credentials are suitable for account client") do

    if client_id_matches_user_account
      test("#get_oauth_token") { pending }
    else
      tests("#get_oauth_token") do
        tests("request access with client credentials") do
          credentials = Fog::Brightbox::OAuth2::CredentialSet.new(@client_id, @secret)
          response = subject.new.get_oauth_token(@connection, credentials)
          tests("#access_token?").returns(true)  { credentials.access_token? }
          tests("#access_token == #{response}").returns(true)  { credentials.access_token == response }
          tests("#refresh_token?").returns(false) { credentials.refresh_token? }
        end
      end
    end
  end

  tests("when credentials are suitable for user application") do
    if client_id_matches_user_account
      tests("#get_oauth_token") do
        tests("request access with user credentials") do
          options = {:username => @username, :password => @password}
          credentials = Fog::Brightbox::OAuth2::CredentialSet.new(@client_id, @secret, options)
          response = subject.new.get_oauth_token(@connection, credentials)

          returns("#{response}")
          tests("#access_token?").returns(true) { credentials.access_token? }
          tests("#access_token == #{response}").returns(true) { credentials.access_token == response }
          tests("#refresh_token?").returns(true) { credentials.refresh_token? }
          @refresh_token = credentials.refresh_token
        end

        tests("request access with refresh token #{@refresh_token}") do
          options = {:refresh_token => @refresh_token}
          credentials = Fog::Brightbox::OAuth2::CredentialSet.new(@client_id, @secret, options)
          response = subject.new.get_oauth_token(@connection, credentials)

          returns("#{response}")
          tests("#access_token?").returns(true) { credentials.access_token? }
          tests("#access_token == #{response}").returns(true) { credentials.access_token == response }
          tests("#refresh_token?").returns(true) { credentials.refresh_token? }
        end

        tests("request access with expired token #{@refresh_token}") do
          options = {:refresh_token => @refresh_token}
          credentials = Fog::Brightbox::OAuth2::CredentialSet.new(@client_id, @secret, options)
          response = subject.new.get_oauth_token(@connection, credentials)

          returns(nil)
          tests("#{@refresh_token} has expired").returns(true) { response.nil? }
        end
      end
    else
      test("#get_oauth_token") { pending }
    end
  end

end
