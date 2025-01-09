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

      it "reports missing IDs" do
        expect { output }.to_not raise_error

        aggregate_failures do
          expect(stderr).to match("ERROR: You must specify image IDs to show")
          expect(stdout).to eq("")
        end
      end
    end

    context "with identifier argument" do
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

        aggregate_failures do
          expect(stderr).to match("")
          expect(stderr).not_to match("ERROR")
          expect(stdout).to match("img-11111")

          expect(stdout).to match("min_ram: 2048")
        end
      end
    end

    context "with multiple identifiers" do
      let(:argv) { %w[images show img-11111 img-22222] }

      before do
        stub_request(:get, "#{api_url}/1.0/images/img-11111?account_id=acc-12345")
          .to_return(
            status: 200,
            body: {
              id: "img-11111",
              min_ram: 2_048
            }.to_json
          )

        stub_request(:get, "#{api_url}/1.0/images/img-22222?account_id=acc-12345")
          .to_return(
            status: 200,
            body: {
              id: "img-22222",
              min_ram: 4_096
            }.to_json
          )
      end

      it "does not error" do
        expect { output }.to_not raise_error

        aggregate_failures do
          expect(stderr).to match("")
          expect(stderr).not_to match("ERROR")

          expect(stdout).to match("img-11111")
          expect(stdout).to match("min_ram: 2048")

          expect(stdout).to match("img-22222")
          expect(stdout).to match("min_ram: 4096")
        end
      end
    end
  end
end
