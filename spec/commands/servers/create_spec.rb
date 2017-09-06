require "spec_helper"

describe "brightbox servers" do

  describe "create" do
    let(:output) { FauxIO.new { Brightbox.run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    before do
      config = config_from_contents(USER_APP_CONFIG_CONTENTS)
      cache_access_token(config, "f83da712e6299cda953513ec07f7a754f747d727")

      stub_request(:post, "http://api.brightbox.dev/token").to_return(
        :status => 200,
        :body => '{"access_token":"44320b29286077c44f14c4efdfed70f63f4a8361","token_type":"Bearer","refresh_token":"759b2b28c228948a0ba5d07a89f39f9e268a95c0","scope":"infrastructure orbit","expires_in":7200}')
    end

    context "without arguments" do
      let(:argv) { %w(servers create) }

      it "does not error" do
        expect { output }.to_not raise_error
      end
    end

    context "with --cloud-ip with nominated IP argument" do
      let(:argv) { %w(servers create --cloud-ip cip-12345 img-12345) }

      let(:image) { double(:id => "img-12345", :name => "Linux") }
      let(:type) { double(:id => "typ-12345", :handle => "nano") }
      let(:zone) { double(:handle => "gb1-a") }

      before do
        expect(Brightbox::Image).to receive(:find).with("img-12345").and_return(image)
        expect(Brightbox::Type).to receive(:find_by_handle).and_return(type)
      end

      it "requests nominated Cloud IP" do
        stub_request(:post, "http://api.brightbox.dev/1.0/servers?account_id=acc-12345")
          .with(:body => /"cloud_ip":"cip-12345"/)
          .and_return(:status => 202, :body => sample_response)

        expect(stderr).to match("mapping cip-12345 when built")
        expect(stderr).not_to match("ERROR")
        expect(stdout).to match("srv-12345")
      end
    end

    context "with --cloud-ip true argument" do
      let(:argv) { %w(servers create --cloud-ip true img-12345) }

      let(:image) { double(:id => "img-12345", :name => "Linux") }
      let(:type) { double(:id => "typ-12345", :handle => "nano") }
      let(:zone) { double(:handle => "gb1-a") }

      before do
        expect(Brightbox::Image).to receive(:find).with("img-12345").and_return(image)
        expect(Brightbox::Type).to receive(:find_by_handle).and_return(type)
      end

      it "requests new allocated Cloud IP" do
        stub_request(:post, "http://api.brightbox.dev/1.0/servers?account_id=acc-12345")
          .with(:body => /"cloud_ip":"true"/)
          .and_return(:status => 202, :body => sample_response)

        expect(stderr).to match("mapping a new cloud IP when built")
        expect(stderr).not_to match("ERROR")
        expect(stdout).to match("srv-12345")
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
