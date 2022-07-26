require "spec_helper"

describe "brightbox images" do
  describe "update" do
    let(:output) { FauxIO.new { Brightbox.run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    before do
      config_from_contents(API_CLIENT_CONFIG_CONTENTS)
      stub_client_token_request
      Brightbox.config.reauthenticate
    end

    context "without arguments" do
      let(:argv) { %w[images update] }

      it "does not error" do
        expect { output }.to_not raise_error

        expect(stderr).to match("ERROR: You must specify the image to update as the first argument")
        expect(stdout).to match("")
      end
    end

    context "with --min-ram" do
      let(:argv) { %w[images update --min-ram 2048 img-12345] }

      before do
        expect(Brightbox::Image).to receive(:find)
          .with("img-12345")
          .and_call_original

        stub_request(:get, "#{api_url}/1.0/images/img-12345?account_id=acc-12345")
          .and_return(
            status: 200,
            body: {
              id: "img-12345",
              min_ram: 1_024
            }.to_json
          )

        stub_request(:put, "#{api_url}/1.0/images/img-12345?account_id=acc-12345")
          .with(body: hash_including(
            min_ram: 2_048
          ))
          .and_return(
            status: 200,
            body: {
              id: "img-12345",
              min_ram: 2_048
            }.to_json
          )
      end

      it "updates min_ram" do
        expect { output }.to_not raise_error

        expect(stderr).to match("")
        expect(stderr).not_to match("ERROR")
        expect(stdout).to match("img-12345")

        # No shown in output
        # expect(stdout).to match("min_ram: 2048")
      end
    end
  end
end
