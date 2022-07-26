module AuthenticationHelpers
  def api_url
    "http://api.brightbox.localhost"
  end

  def stub_client_token_request
    stub_request(:post, "http://api.brightbox.localhost/token").to_return(
      :status => 200,
      :body => '{"access_token":"44320b29286077c44f14c4efdfed70f63f4a8361","token_type":"Bearer","refresh_token":"759b2b28c228948a0ba5d07a89f39f9e268a95c0","scope":"infrastructure orbit","expires_in":7200}'
    )
  end

  def stub_token_request(two_factor: false)
    auth_response = {
      status: 200,
      body: {
        access_token: "17e9282e40b8a2f1366107a068a1632bb65d3dec",
        token_type: "Bearer",
        refresh_token: "b77913a13cccfdd44294b4b161494a652d48b635",
        scope: "infrastructure, orbit",
        expires_in: 7200
      }.to_json
    }

    if two_factor
      stub_request(:post, "#{api_url}/token")
        .with(
          body: {
            grant_type: "password",
            username: "jason.null@brightbox.com",
            password: "N:B3e%7Cmh"
          }.to_json
        )
        .to_return(
          status: 401,
          headers: {
            "X-Brightbox-OTP" => "required"
          },
          body: { error: "invalid_client" }.to_json
        )

      stub_request(:post, "#{api_url}/token")
        .with(
          headers: {
            "X-Brightbox-OTP" => "123456"
          },
          body: {
            grant_type: "password",
            username: "jason.null@brightbox.com",
            password: "N:B3e%7Cmh+123456"
          }.to_json
        )
        .to_return(auth_response)
    else
      stub_request(:post, "#{api_url}/token")
        .with(
          body: {
            grant_type: "password",
            username: "jason.null@brightbox.com",
            password: "N:B3e%7Cmh"
          }.to_json
        )
        .to_return(auth_response)
    end
  end

  def stub_accounts_request
    stub_request(:get, "#{api_url}/1.0/accounts?nested=false")
      .to_return(
        status: 200,
        headers: { "Content-Type": "application/json" },
        body: [
          {
            id: "acc-12345",
            resource_type: "account",
            url: "https://api.gb1.brightbox.com/1.0/accounts/acc-12345",
            name: "CLI test account",
            status: "active",
            ram_limit: 3_200_000,
            ram_used: 0,
            dbs_ram_limit: 32_768,
            dbs_ram_used: 0,
            cloud_ips_limit: 32,
            cloud_ips_used: 0,
            load_balancers_limit: 5,
            load_balancers_used: 0,
            owner: {
              id: "usr-12345",
              resource_type: "user",
              url: "https://api.gb1.brightbox.com/1.0/users/usr-12345",
              name: "Jason Null",
              email_address: "jason.null@brightbox.com"
            }
          }
        ].to_json
      )
  end
end
