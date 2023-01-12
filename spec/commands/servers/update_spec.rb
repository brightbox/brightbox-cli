require "spec_helper"

describe "brightbox servers update" do
  let(:output) { FauxIO.new { Brightbox.run(argv) } }
  let(:stdout) { output.stdout }
  let(:stderr) { output.stderr }

  before do
    config_from_contents(API_CLIENT_CONFIG_CONTENTS)

    stub_request(:post, "http://api.brightbox.localhost/token")
      .to_return(
        status: 200,
        body: JSON.dump(
          access_token: "ACCESS-TOKEN",
          refresh_token: "REFRESH_TOKEN"
        )
      )

    Brightbox.config.reauthenticate
  end

  context "without arguments" do
    let(:argv) { %w[servers update] }

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to eq("ERROR: You must specify a valid server id as the first argument\n")

      expect(stdout).to match("")
    end
  end

  context "without options" do
    let(:argv) { %w[servers update srv-klfkd] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/servers/srv-klfkd?account_id=acc-12345")
        .to_return(:status => 200, :body => {
          id: "srv-klfkd",
          server_type: {
           id: "typ-12345"
          },
          cloud_ips: [],
          interfaces: []
        }.to_json)

      stub_request(:get, "http://api.brightbox.localhost/1.0/images?account_id=acc-12345")
        .to_return(:status => 200, :body => [{id: "img-12345" }].to_json)

      stub_request(:put, "http://api.brightbox.localhost/1.0/servers/srv-klfkd?account_id=acc-12345")
        .with(:body => {
          compatibility_mode: false
        })
        .to_return(:status => 200, :body => {
           id: "srv-klfkd",
           server_type: {
            id: "typ-12345"
           },
           cloud_ips: [],
           interfaces: []
        }.to_json)
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to eq("Updating server srv-klfkd\n")

      expect(stdout).to match("srv-klfkd")
    end
  end

  context "with --compatibility-mode" do
    let(:argv) { %w[servers update --compatibility-mode srv-ds321] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/servers/srv-ds321?account_id=acc-12345")
        .to_return(:status => 200, :body => {
          id: "srv-ds321",
          server_type: {
           id: "typ-12345"
          },
          cloud_ips: [],
          interfaces: []
        }.to_json)

      stub_request(:get, "http://api.brightbox.localhost/1.0/images?account_id=acc-12345")
        .to_return(:status => 200, :body => [{id: "img-12345" }].to_json)

      stub_request(:put, "http://api.brightbox.localhost/1.0/servers/srv-ds321?account_id=acc-12345")
        .with(:body => {})
        .to_return(:status => 200, :body => {
           id: "srv-ds321",
           server_type: {
            id: "typ-12345"
           },
           cloud_ips: [],
           interfaces: []
        }.to_json)
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to eq("Updating server srv-ds321\n")

      expect(stdout).to match("srv-ds321")
    end
  end

  context "with --no-compatibility-mode" do
    let(:argv) { %w[servers update --no-compatibility-mode srv-ds321] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/servers/srv-ds321?account_id=acc-12345")
        .to_return(:status => 200, :body => {
          id: "srv-ds321",
          server_type: {
           id: "typ-12345"
          },
          cloud_ips: [],
          interfaces: []
        }.to_json)

      stub_request(:get, "http://api.brightbox.localhost/1.0/images?account_id=acc-12345")
        .to_return(:status => 200, :body => [{id: "img-12345" }].to_json)

      stub_request(:put, "http://api.brightbox.localhost/1.0/servers/srv-ds321?account_id=acc-12345")
        .with(:body => {
          compatibility_mode: false
        })
        .to_return(:status => 200, :body => {
           id: "srv-ds321",
           server_type: {
            id: "typ-12345"
           },
           cloud_ips: [],
           interfaces: []
        }.to_json)
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to eq("Updating server srv-ds321\n")

      expect(stdout).to match("srv-ds321")
    end
  end

  context "with --base64" do
    let(:argv) { %w[servers update --base64 srv-ds321] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/servers/srv-ds321?account_id=acc-12345")
        .to_return(:status => 200, :body => {
          id: "srv-ds321",
          server_type: {
           id: "typ-12345"
          },
          cloud_ips: [],
          interfaces: []
        }.to_json)

      stub_request(:get, "http://api.brightbox.localhost/1.0/images?account_id=acc-12345")
        .to_return(:status => 200, :body => [{id: "img-12345" }].to_json)

      stub_request(:put, "http://api.brightbox.localhost/1.0/servers/srv-ds321?account_id=acc-12345")
        .with(:body => {
          compatibility_mode: false
        })
        .to_return(:status => 200, :body => {
           id: "srv-ds321",
           server_type: {
            id: "typ-12345"
           },
           cloud_ips: [],
           interfaces: []
        }.to_json)
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to eq("Updating server srv-ds321\n")

      expect(stdout).to match("srv-ds321")
    end
  end

  context "with --base64 --user-data" do
    let(:argv) { %w[servers update --base64 --user-data hello srv-ds321] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/servers/srv-ds321?account_id=acc-12345")
        .to_return(:status => 200, :body => {
          id: "srv-ds321",
          server_type: {
           id: "typ-12345"
          },
          cloud_ips: [],
          interfaces: []
        }.to_json)

      stub_request(:get, "http://api.brightbox.localhost/1.0/images?account_id=acc-12345")
        .to_return(:status => 200, :body => [{id: "img-12345" }].to_json)

      stub_request(:put, "http://api.brightbox.localhost/1.0/servers/srv-ds321?account_id=acc-12345")
        .with(:body => {
          user_data: "aGVsbG8=\n"
        })
        .to_return(:status => 200, :body => {
           id: "srv-ds321",
           server_type: {
            id: "typ-12345"
           },
           cloud_ips: [],
           interfaces: []
        }.to_json)
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to eq("Updating server srv-ds321 with 0.01k of user data\n")

      expect(stdout).to match("srv-ds321")
    end
  end

  context "with --no-base64 --user-data" do
    let(:argv) { %w[servers update --no-base64 --user-data hello srv-ds321] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/servers/srv-ds321?account_id=acc-12345")
        .to_return(:status => 200, :body => {
          id: "srv-ds321",
          server_type: {
           id: "typ-12345"
          },
          cloud_ips: [],
          interfaces: []
        }.to_json)

      stub_request(:get, "http://api.brightbox.localhost/1.0/images?account_id=acc-12345")
        .to_return(:status => 200, :body => [{id: "img-12345" }].to_json)

      stub_request(:put, "http://api.brightbox.localhost/1.0/servers/srv-ds321?account_id=acc-12345")
        .with(:body => {
          user_data: "hello"
        })
        .to_return(:status => 200, :body => {
           id: "srv-ds321",
           server_type: {
            id: "typ-12345"
           },
           cloud_ips: [],
           interfaces: []
        }.to_json)
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to eq("Updating server srv-ds321 with 0.00k of user data\n")

      expect(stdout).to match("srv-ds321")
    end
  end
end
