require "spec_helper"

RSpec.describe "brightbox images" do
  describe "show" do
    let(:output) { FauxIO.new { Brightbox.run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    before do
      WebMock.reset!

      config_from_contents(API_CLIENT_CONFIG_CONTENTS)
      stub_client_token_request
      Brightbox.config.reauthenticate
    end

    context "without arguments" do
      let(:argv) { %w[images show] }

      before do
        stub_request(:get, "#{api_url}/1.0/images?account_id=acc-12345")
          .to_return(
            status: 200,
            body: [
              {
                id: "img-12345"
              }
            ].to_json
          )
      end

      it "does not error" do
        expect { output }.to_not raise_error

        expect(stderr).to match("")
        expect(stderr).not_to match("ERROR")
        expect(stdout).to match("img-12345")
      end
    end

    context "with identifier" do
      let(:argv) { %w[images show img-11111] }

      before do
        expect(Brightbox::Image).to receive(:find)
          .with("img-11111")
          .and_call_original

        stub_request(:get, "#{api_url}/1.0/images/img-11111?account_id=acc-12345")
          .to_return(
            status: 200,
            body: {
              id: "img-11111",
              min_ram: 2_048
            }.to_json
          )
      end

      it "does not error" do
        expect { output }.to_not raise_error

        expect(stderr).to match("")
        expect(stderr).not_to match("ERROR")
        expect(stdout).to match("img-11111")

        expect(stdout).to match("min_ram: 2048")
      end
    end
  end
end
