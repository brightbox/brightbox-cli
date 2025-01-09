require "spec_helper"

describe "brightbox users" do
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
      let(:argv) { %w[users show] }

      it "does not error" do
        expect { output }.to_not raise_error

        aggregate_failures do
          expect(stderr).to match("ERROR: You must specify user IDs to show")
          expect(stdout).to be_empty
        end
      end
    end

    context "with identifier argument" do
      let(:argv) { %w[users show usr-90781] }

      before do
        # FIXME: Two requests, one with the parameter and one without
        #        One for ALL tests (with VCR breaking things)
        #        One for this test standalone
        stub_request(:get, "#{api_url}/1.0/users/usr-90781")
          .to_return(
            status: 200,
            body: {
              id: "usr-90781",
              email_address: "user@domain.test",
              accounts: [
                {
                  id: "acc-12345",
                  name: "Test account"
                }
              ]
            }.to_json
          )

        # Same again but supporting the account_id parameter
        stub_request(:get, "#{api_url}/1.0/users/usr-90781")
          .with(query: hash_including(account_id: "acc-12345"))
          .to_return(
            status: 200,
            body: {
              id: "usr-90781",
              email_address: "user@domain.test",
              accounts: [
                {
                  id: "acc-12345",
                  name: "Test account"
                }
              ]
            }.to_json
          )
      end

      it "does not error" do
        expect { output }.to_not raise_error

        aggregate_failures do
          expect(stderr).to match("")
          expect(stderr).not_to match("ERROR")
          expect(stdout).to match("usr-90781")
          expect(stdout).to match("email_address: user@domain.test")
        end
      end
    end
  end
end
