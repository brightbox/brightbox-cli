require "spec_helper"

describe "brightbox lbs" do
  describe "update" do
    let(:output) { FauxIO.new { Brightbox.run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    before do
      config = config_from_contents(USER_APP_CONFIG_CONTENTS)
      cache_access_token(config, "f83da712e6299cda953513ec07f7a754f747d727")
    end

    context "" do
      let(:argv) { %w[lbs update] }

      it "does not error" do
        expect { output }.to_not raise_error
      end
    end

    context "--ssl-min-ver=TLSv1.0" do
      let(:argv) { ["lbs", "update", "--ssl-min-ver", "TLSv1.0", "lba-12345"] }

      let(:json_response) do
        <<-EOS
        {
          "id":"lba-12345",
          "ssl_minimum_version":"TLSv1.0"
        }
        EOS
      end

      before do
        stub_request(:get, "http://api.brightbox.localhost/1.0/load_balancers/lba-12345?account_id=acc-12345")
          .to_return(:status => 200, :body => '{"id":"lba-12345"}')

        stub_request(:put, "http://api.brightbox.localhost/1.0/load_balancers/lba-12345?account_id=acc-12345")
          .with(:body => { ssl_minimum_version: "TLSv1.0" })
          .to_return(:status => 202, :body => json_response)
      end

      it "includes ssl_minimum_version in response" do
        expect(stderr).to eq("Updating load balancer lba-12345\n")
        expect(stdout).to include("lba-12345")
      end
    end

    context "--sslv3" do
      let(:argv) { ["lbs", "update", "--sslv3", "lba-grt24"] }

      let(:json_response) do
        <<-EOS
        {
          "id":"lba-grt24",
          "ssl_minimum_version":"TLSv1.0"
        }
        EOS
      end

      before do
        stub_request(:get, "http://api.brightbox.localhost/1.0/load_balancers/lba-grt24?account_id=acc-12345")
          .to_return(:status => 200, :body => '{"id":"lba-grt24"}')

        stub_request(:put, "http://api.brightbox.localhost/1.0/load_balancers/lba-grt24?account_id=acc-12345")
          .with(:body => { sslv3: true })
          .to_return(:status => 202, :body => json_response)
      end

      it "includes ssl_minimum_version in response" do
        expect(stderr).to eq("Updating load balancer lba-grt24\n")
        expect(stdout).to include("lba-grt24")
      end
    end

    context "--no-sslv3" do
      let(:argv) { ["lbs", "update", "--no-sslv3", "lba-kl432"] }

      let(:json_response) do
        <<-EOS
        {
          "id":"lba-kl432",
          "ssl_minimum_version":"TLSv1.0"
        }
        EOS
      end

      before do
        stub_request(:get, "http://api.brightbox.localhost/1.0/load_balancers/lba-kl432?account_id=acc-12345")
          .to_return(:status => 200, :body => '{"id":"lba-kl432"}')

        stub_request(:put, "http://api.brightbox.localhost/1.0/load_balancers/lba-kl432?account_id=acc-12345")
          .with(:body => { sslv3: false })
          .to_return(:status => 202, :body => json_response)
      end

      it "includes ssl_minimum_version in response" do
        expect(stderr).to eq("Updating load balancer lba-kl432\n")
        expect(stdout).to include("lba-kl432")
      end
    end
  end
end
