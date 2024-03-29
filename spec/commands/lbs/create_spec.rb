require "spec_helper"

describe "brightbox lbs" do
  describe "create" do
    let(:output) { FauxIO.new { Brightbox.run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    before do
      config = config_from_contents(USER_APP_CONFIG_CONTENTS)
      cache_access_token(config, "f83da712e6299cda953513ec07f7a754f747d727")
    end

    context "" do
      let(:argv) { %w[lbs create] }

      it "does not error" do
        expect { output }.to_not raise_error
      end
    end

    context "--ssl-min-ver=TLSv1.0" do
      let(:argv) { ["lbs", "create", "--ssl-min-ver", "TLSv1.0", "srv-12345"] }
      let(:expected_args) { { ssl_minimum_version: "TLSv1.0" } }

      let(:json_response) do
        <<-EOS
        {
          "id":"lba-12345",
          "ssl_minimum_version":"TLSv1.0"
        }
        EOS
      end

      before do
        stub_request(:post, "http://api.brightbox.localhost/1.0/load_balancers?account_id=acc-12345")
          .with(:body => hash_including("ssl_minimum_version" => "TLSv1.0"))
          .to_return(:status => 202, :body => json_response)
      end

      it "includes ssl_minimum_version in response" do
        expect(Brightbox::LoadBalancer).to receive(:create).with(hash_including(expected_args)).and_call_original
        expect(stderr).to eq("Creating a new load balancer\n")
        expect(stdout).to include("lba-12345")
      end
    end
  end
end
