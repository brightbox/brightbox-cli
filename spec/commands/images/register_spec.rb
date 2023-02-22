require "spec_helper"

describe "brightbox images" do
  describe "register" do
    let(:output) { FauxIO.new { Brightbox.run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    before do
      config_from_contents(API_CLIENT_CONFIG_CONTENTS)
      stub_client_token_request
      Brightbox.config.reauthenticate
    end

    context "without arguments" do
      let(:argv) { %w[images register] }

      it "does not error" do
        expect { output }.to_not raise_error

        expect(stderr).to match("ERROR: You must specify the architecture")
        expect(stdout).to match("")
      end
    end

    context "without any source" do
      let(:argv) { %w[images register --arch x86_64] }

      it "does not error" do
        expect { output }.to_not raise_error

        expect(stderr).to match("ERROR: You must specify one of 'server', 'url', or 'volume'")
        expect(stdout).to match("")
      end
    end

    context "with mutually exclusive arguments" do
      let(:argv) { %w[images register --arch x86_64 --server srv-12345 --url http://example.com/test.img] }

      it "does not error" do
        expect { output }.to_not raise_error

        expect(stderr).to match("ERROR: You cannot register from multiple sources. Use either 'server', 'url', or 'volume'")
        expect(stdout).to match("")
      end
    end

    context "with 'server' argument" do
      let(:argv) { %w[images register --arch x86_64 --server srv-12345] }

      before do
        expect(Brightbox::Image).to receive(:register)
          .with(hash_including(
                  arch: "x86_64",
                  server: "srv-12345"
                ))
          .and_call_original

        stub_request(:post, "#{api_url}/1.0/images?account_id=acc-12345")
          .with(body: /"server":"srv-12345"/)
          .to_return(
            status: 201,
            body: {
              id: "img-12345"
            }.to_json
          )

        stub_request(:get, "#{api_url}/1.0/images/img-12345?account_id=acc-12345")
          .to_return(
            status: 200,
            body: {
              id: "img-12345"
            }.to_json
          )
      end

      it "does not error" do
        expect { output }.to_not raise_error

        expect(stderr).to match("")
        expect(stderr).not_to match("ERROR")
        expect(stdout).to match("img-12345")
      end
    end

    context "with 'url' argument" do
      let(:argv) { %w[images register --arch x86_64 --url https://example.com/os-22.iso] }

      before do
        expect(Brightbox::Image).to receive(:register)
          .with(hash_including(
                  arch: "x86_64",
                  http_url: "https://example.com/os-22.iso"
                ))
          .and_call_original

        stub_request(:post, "#{api_url}/1.0/images?account_id=acc-12345")
          .with(body: %r{"http_url":"https://example.com/os-22.iso"})
          .to_return(
            status: 201,
            body: {
              id: "img-12345"
            }.to_json
          )

        stub_request(:get, "#{api_url}/1.0/images/img-12345?account_id=acc-12345")
          .to_return(
            status: 200,
            body: {
              id: "img-12345"
            }.to_json
          )
      end

      it "does not error" do
        expect { output }.to_not raise_error

        expect(stderr).to match("")
        expect(stderr).not_to match("ERROR")
        expect(stdout).to match("img-12345")
      end
    end

    context "with 'volume' argument" do
      let(:argv) { %w[images register --arch x86_64 --volume vol-12345] }

      before do
        expect(Brightbox::Image).to receive(:register)
          .with(hash_including(
                  arch: "x86_64",
                  volume: "vol-12345"
                ))
          .and_call_original

        stub_request(:post, "#{api_url}/1.0/images?account_id=acc-12345")
          .with(body: /"volume":"vol-12345"/)
          .to_return(
            status: 201,
            body: {
              id: "img-12345"
            }.to_json
          )

        stub_request(:get, "#{api_url}/1.0/images/img-12345?account_id=acc-12345")
          .to_return(
            status: 200,
            body: {
              id: "img-12345"
            }.to_json
          )
      end

      it "does not error" do
        expect { output }.to_not raise_error

        expect(stderr).to match("")
        expect(stderr).not_to match("ERROR")
        expect(stdout).to match("img-12345")
      end
    end

    context "with min-ram argument" do
      let(:argv) { %w[images register --arch x86_64 --url https://example.com/os-22.iso --min-ram 2048] }

      before do
        expect(Brightbox::Image).to receive(:register)
          .with(hash_including(
                  arch: "x86_64",
                  min_ram: 2048,
                  http_url: "https://example.com/os-22.iso"
                ))
          .and_call_original

        stub_request(:post, "#{api_url}/1.0/images?account_id=acc-12345")
          .with(body: /"min_ram":2048/)
          .to_return(
            status: 201,
            body: {
              id: "img-12345"
            }.to_json
          )

        stub_request(:get, "#{api_url}/1.0/images/img-12345?account_id=acc-12345")
          .to_return(
            status: 200,
            body: {
              id: "img-12345",
              min_ram: 2048
            }.to_json
          )
      end

      it "does not error" do
        expect { output }.to_not raise_error

        expect(stderr).to match("")
        expect(stderr).not_to match("ERROR")
        expect(stdout).to match("img-12345")
      end
    end
  end
end
