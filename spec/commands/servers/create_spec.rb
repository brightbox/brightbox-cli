require "spec_helper"

describe "brightbox servers" do
  describe "create" do
    let(:output) { FauxIO.new { Brightbox.run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    let(:image) { double(:id => "img-12345", :name => "Linux") }
    let(:type) { double(:id => "typ-12345", :handle => "nano") }
    let(:zone) { double(:handle => "gb1-a") }

    before do
      config = config_from_contents(USER_APP_CONFIG_CONTENTS)
      cache_access_token(config, "f83da712e6299cda953513ec07f7a754f747d727")

      stub_request(:post, "http://api.brightbox.localhost/token").to_return(
        :status => 200,
        :body => '{"access_token":"44320b29286077c44f14c4efdfed70f63f4a8361","token_type":"Bearer","refresh_token":"759b2b28c228948a0ba5d07a89f39f9e268a95c0","scope":"infrastructure orbit","expires_in":7200}'
      )
    end

    context "without arguments" do
      let(:argv) { %w[servers create] }

      it "does not error" do
        expect { output }.to_not raise_error
      end
    end

    context "with image argument" do
      let(:argv) { %w[servers create img-12345] }

      before do
        expect(Brightbox::Image).to receive(:find).with("img-12345").and_return(image)
        expect(Brightbox::Type).to receive(:find_by_handle).and_return(type)
      end

      it "does not error" do
        stub_request(:post, "http://api.brightbox.localhost/1.0/servers?account_id=acc-12345")
          .with(:body => {
            image: "img-12345",
            server_type: "typ-12345"
          })
          .and_return(:status => 202, :body => sample_response)

        expect(stderr).not_to match("ERROR")
        expect(stdout).to match("srv-12345")
      end
    end

    context "with --cloud-ip with nominated IP argument" do
      let(:argv) { %w[servers create --cloud-ip cip-12345 img-12345] }

      before do
        expect(Brightbox::Image).to receive(:find).with("img-12345").and_return(image)
        expect(Brightbox::Type).to receive(:find_by_handle).and_return(type)
      end

      it "requests nominated Cloud IP" do
        stub_request(:post, "http://api.brightbox.localhost/1.0/servers?account_id=acc-12345")
          .with(:body => /"cloud_ip":"cip-12345"/)
          .and_return(:status => 202, :body => sample_response)

        expect(stderr).to match("mapping cip-12345 when built")
        expect(stderr).not_to match("ERROR")
        expect(stdout).to match("srv-12345")
      end
    end

    context "with --cloud-ip true argument" do
      let(:argv) { %w[servers create --cloud-ip true img-12345] }

      before do
        expect(Brightbox::Image).to receive(:find).with("img-12345").and_return(image)
        expect(Brightbox::Type).to receive(:find_by_handle).and_return(type)
      end

      it "requests new allocated Cloud IP" do
        stub_request(:post, "http://api.brightbox.localhost/1.0/servers?account_id=acc-12345")
          .with(:body => /"cloud_ip":"true"/)
          .and_return(:status => 202, :body => sample_response)

        expect(stderr).to match("mapping a new cloud IP when built")
        expect(stderr).not_to match("ERROR")
        expect(stdout).to match("srv-12345")
      end
    end

    context "with --disk-encrypted switch" do
      let(:argv) { %w[servers create --disk-encrypted img-12345] }

      before do
        expect(Brightbox::Image).to receive(:find).with("img-12345").and_return(image)
        expect(Brightbox::Type).to receive(:find_by_handle).and_return(type)
      end

      it "requests new server with encryption at rest enabled" do
        stub_request(:post, "http://api.brightbox.localhost/1.0/servers?account_id=acc-12345")
          .with(headers: { "Content-Type" => "application/json" },
                body: {
                  disk_encrypted: true,
                  image: "img-12345",
                  server_type: "typ-12345"
                })
          .and_return(:status => 202, :body => sample_response)

        expect(stderr).to match("Creating a nano")
        expect(stderr).not_to match("ERROR")
        expect(stdout).to match("srv-12345")
      end
    end

    context "with --server-groups flag" do
      let(:argv) { %w[servers create --server-groups grp-12345,grp-67890 img-12345] }
      let(:group_ids) { %w(grp-12345 grp-67890) }
      let(:group_one) { double(:id => "grp-12345") }
      let(:group_two) { double(:id => "grp-67890") }

      before do
        expect(Brightbox::Image).to receive(:find).with("img-12345").and_return(image)
        expect(Brightbox::Type).to receive(:find_by_handle).and_return(type)
        expect(Brightbox::ServerGroup).to receive(:find_or_call).with(group_ids).and_return([group_one, group_two])
      end

      it "requests new server be in both server groups" do
        stub_request(:post, "http://api.brightbox.localhost/1.0/servers?account_id=acc-12345")
          .with(:headers => { "Content-Type" => "application/json" },
                :body => hash_including(:server_groups => group_ids))
          .and_return(:status => 202, :body => sample_response)

        expect(stderr).to match("Creating a nano")
        expect(stderr).not_to match("ERROR")
        expect(stdout).to match("srv-12345")
      end
    end

    context "without --server-groups flag" do
      let(:argv) { %w[servers create img-12345] }

      before do
        expect(Brightbox::Image).to receive(:find).with("img-12345").and_return(image)
        expect(Brightbox::Type).to receive(:find_by_handle).and_return(type)
      end

      it "requests new server be in both server groups" do
        stub_request(:post, "http://api.brightbox.localhost/1.0/servers?account_id=acc-12345")
          .with(:headers => { "Content-Type" => "application/json" })
          .with { |request| hash_excluding("server_groups") === JSON.parse(request.body) }
          .and_return(:status => 202, :body => sample_response)

        expect(stderr).to match("Creating a nano")
        expect(stderr).not_to match("ERROR")
        expect(stdout).to match("srv-12345")
      end
    end

    context "with --volume-size switch", vcr: false do
      context "with network storage" do
        let(:argv) { %w[servers create --type=2gb.nbs --volume-size=10000 img-12345] }

        before do
          expect(Brightbox::Image).to receive(:find).with("img-12345").and_return(image)
          expect(Brightbox::Type).to receive(:find_by_handle).and_return(type)
        end

        it "requests new server with a custom volume size" do
          stub_request(:post, "http://api.brightbox.localhost/1.0/servers?account_id=acc-12345")
            .with(:headers => { "Content-Type" => "application/json" },
                  body: hash_including(volumes: [{ image: "img-12345", size: 10000 }]))
            .and_return(status: 202, body: sample_response)

          expect(stderr).not_to match("ERROR")
          expect(stdout).to match("srv-12345")
        end
      end

      context "without network storage type" do
        let(:argv) { %w[servers create --type=nano --volume-size=10000 img-12345] }

        before do
          expect(Brightbox::Image).to receive(:find).with("img-12345").and_return(image)
          expect(Brightbox::Type).to receive(:find_by_handle).and_return(type)
        end

        it "requests new server with a custom volume size" do
          stub_request(:post, "http://api.brightbox.localhost/1.0/servers?account_id=acc-12345")
            .with(:headers => { "Content-Type" => "application/json" },
                  body: hash_including(volumes: [{ image: "img-12345", size: 10000 }]))
            .and_return(status: 202, body: sample_response)

          expect(stderr).not_to match("ERROR")
          expect(stdout).to match("srv-12345")
        end
      end
    end

    context "with --user-data flag" do
      before do
        expect(Brightbox::Image).to receive(:find).with("img-12345").and_return(image)
        expect(Brightbox::Type).to receive(:find_by_handle).and_return(type)
      end

      context "with user data string within limit" do
        let(:argv) { ["servers", "create", "--user-data", user_data, "--no-base64", "img-12345"] }
        let(:user_data) { ("a" * 65_535) }

        it "requests new server with user data" do
          stub_request(:post, "http://api.brightbox.localhost/1.0/servers?account_id=acc-12345")
            .with(:headers => { "Content-Type" => "application/json" },
                  body: hash_including(user_data: user_data))
            .and_return(status: 202, body: sample_response)

          aggregate_failures do
            expect(stderr).not_to match("ERROR")
            expect(stdout).to match("srv-12345")
          end
        end
      end

      context "with user data string encoded by client" do
        let(:argv) { ["servers", "create", "--user-data", user_data, "--base64", "img-12345"] }
        let(:encoded_user_data) { Base64.encode64(user_data) }
        let(:user_data) { ("a" * 48_345) }

        it "requests new server with user data" do
          stub_request(:post, "http://api.brightbox.localhost/1.0/servers?account_id=acc-12345")
            .with(:headers => { "Content-Type" => "application/json" },
                  body: hash_including(user_data: encoded_user_data))
            .and_return(status: 202, body: sample_response)

          aggregate_failures do
            expect(stderr).not_to match("ERROR")
            expect(stdout).to match("srv-12345")
          end
        end
      end

      context "with user data string exceeding limit" do
        let(:argv) { ["servers", "create", "--user-data", user_data, "img-12345"] }
        let(:user_data) { ("a" * 65_535) + "b" }

        it "errors" do
          expect(stderr).to match("Encoded user-data exceeds 64KiB limit")
          expect(stdout).not_to match("srv-12345")
        end
      end
    end

    def sample_response
      '{
        "id": "srv-12345",
        "image": {
          "id": "img-12345"
        },
        "interfaces": [],
        "server_type": {
          "handle": "nano"
        },
        "zone": {
          "handle": "gb1-a"
        },
        "cloud_ips": [],
        "snapshots": []
      }'
    end
  end
end
