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

    context "without required nodes arguments" do
      let(:argv) { %w[lbs create] }

      it "does not error" do
        expect { output }.to_not raise_error

        expect(stderr).to eq("ERROR: You must specify which servers to balance connections to\n")
      end
    end

    context "with required nodes arguments" do
      let(:argv) { %w[lbs create srv-12345] }
      let(:expected_args) { { nodes: [{ node: "srv-12345" }] } }

      let(:json_response) do
        <<~EOS
        {
          "id": "lba-12345",
          "nodes": [
            {
              "id": "srv-12345"
            }
          ]
        }
        EOS
      end

      before do
        stub_request(:post, "http://api.brightbox.localhost/1.0/load_balancers?account_id=acc-12345")
          .with(:body => hash_including("nodes" => [{ "node" => "srv-12345" }]))
          .to_return(:status => 202, :body => json_response)
      end

      it "makes request" do
        expect(Brightbox::LoadBalancer).to receive(:create).with(hash_including(expected_args)).and_call_original

        expect(stderr).to eq("Creating a new load balancer\n")
        expect(stdout).to include("lba-12345")
      end
    end

    context "with required nodes arguments" do
      let(:argv) { %w[lbs create srv-12345] }
      let(:expected_args) { { nodes: [{ node: "srv-12345" }] } }

      let(:json_response) do
        <<~EOS
        {
          "id": "lba-12345",
          "nodes": [
            {
              "id": "srv-12345"
            }
          ]
        }
        EOS
      end

      before do
        stub_request(:post, "http://api.brightbox.localhost/1.0/load_balancers?account_id=acc-12345")
          .with(:body => hash_including("nodes" => [{ "node" => "srv-12345" }]))
          .to_return(:status => 202, :body => json_response)
      end

      it "makes request" do
        expect(Brightbox::LoadBalancer).to receive(:create).with(hash_including(expected_args)).and_call_original

        expect(stderr).to eq("Creating a new load balancer\n")
        expect(stdout).to include("lba-12345")
      end
    end

    context "with multiple nodes" do
      let(:argv) { %w[lbs create srv-12345 srv-54321] }
      let(:expected_args) { { nodes: [{ node: "srv-12345" }, { node: "srv-54321" }] } }

      let(:json_response) do
        <<~EOS
        {
          "id": "lba-12345",
          "nodes": [
            {
              "id": "srv-12345"
            },
            {
              "id": "srv-54321"
            }
          ]
        }
        EOS
      end

      before do
        stub_request(:post, "http://api.brightbox.localhost/1.0/load_balancers?account_id=acc-12345")
          .with(:body => hash_including("nodes" => [{ "node" => "srv-12345" }, { "node" => "srv-54321" }]))
          .to_return(:status => 202, :body => json_response)
      end

      it "makes request" do
        expect(Brightbox::LoadBalancer).to receive(:create).with(hash_including(expected_args)).and_call_original

        expect(stderr).to eq("Creating a new load balancer\n")
        expect(stdout).to include("lba-12345")
      end
    end

    context "with --buffer_size" do
      let(:argv) { %w[lbs create --buffer-size 1024 srv-12345] }
      let(:expected_args) { { nodes: [{ node: "srv-12345" }], buffer_size: 1024 } }

      let(:json_response) do
        <<~EOS
        {
          "id": "lba-12345",
          "buffer_size": 1024
        }
        EOS
      end

      before do
        stub_request(:post, "http://api.brightbox.localhost/1.0/load_balancers?account_id=acc-12345")
          .with(:body => hash_including("buffer_size" => 1024))
          .to_return(:status => 202, :body => json_response)
      end

      it "includes buffer_size in response" do
        expect(Brightbox::LoadBalancer).to receive(:create).with(hash_including(expected_args)).and_call_original

        expect(stderr).to eq("Creating a new load balancer\n")
        expect(stdout).to include("lba-12345")
      end
    end

    context "with --ssl-min-ver=TLSv1.0" do
      let(:argv) { ["lbs", "create", "--ssl-min-ver", "TLSv1.0", "srv-12345"] }
      let(:expected_args) { { ssl_minimum_version: "TLSv1.0" } }

      let(:json_response) do
        <<~EOS
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
