require "spec_helper"

describe "brightbox servers" do
  describe "activate_console" do
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
      let(:argv) { %w[servers activate_console] }

      it "does not error" do
        expect { output }.to_not raise_error

        aggregate_failures do
          expect(stderr).to match("ERROR: You must specify servers to activate the console for")
          expect(stdout).to be_empty
        end
      end
    end

    context "with identifier argument" do
      let(:argv) { %w[servers activate_console srv-lv426] }
      let(:token_expires) { "2025-01-01T01:01:01Z" }

      before do
        stub_request(:get, "#{api_url}/1.0/servers/srv-lv426")
          .with(query: hash_including(account_id: "acc-12345"))
          .to_return(
            status: 200,
            body: {
              id: "srv-lv426",
              console_token: nil,
              console_token_expires: nil,
              console_url: nil,
              image: {
                id: "img-12345"
              }
            }.to_json
          )

        stub_request(:get, "#{api_url}/1.0/images")
          .with(query: hash_including(account_id: "acc-12345"))
          .to_return(
            status: 200,
            body: [
              {
                id: "img-12345"
              }
            ].to_json
          )

        stub_request(:post, "#{api_url}/1.0/servers/srv-lv426/activate_console")
          .with(query: hash_including(account_id: "acc-12345"))
          .to_return(
            status: 202,
            body: {
              id: "srv-lv426",
              console_token: "<test-token-placeholder>",
              console_token_expires: token_expires,
              console_url: "https://console.test.test/srv-lv426",
              image: {
                id: "img-12345"
              }
            }.to_json
          )
      end

      context "when in different time zone" do
        around do |example|
          original_tz = ENV["TZ"]
          example.run
          ENV["TZ"] = original_tz
        end

        context "when in UTC" do
          before do
            ENV["TZ"] = "Europe/London"
          end

          context "without daylight savings" do
            it "does not error" do
              expect { output }.to_not raise_error

              aggregate_failures do
                expect(stderr).to match("")
                expect(stderr).not_to match("ERROR")

                expect(stdout).to match("url")
                expect(stdout).to match("https://console.test.test/srv-lv426")

                expect(stdout).to match("token")
                expect(stdout).to match("<test-token-placeholder>")

                expect(stdout).to match("expires")
                expect(stdout).to match("2025-01-01T01:01")
              end
            end
          end

          context "with daylight savings (BST)" do
            let(:token_expires) { "2025-07-01T01:01:01Z" }

            it "does not error" do
              expect { output }.to_not raise_error

              aggregate_failures do
                expect(stderr).to match("")
                expect(stderr).not_to match("ERROR")

                expect(stdout).to match("url")
                expect(stdout).to match("https://console.test.test/srv-lv426")

                expect(stdout).to match("token")
                expect(stdout).to match("<test-token-placeholder>")

                expect(stdout).to match("expires")
                expect(stdout).to match("2025-07-01T02:01")
              end
            end
          end
        end

        context "when in EST" do
          around do |example|
            ENV["TZ"] = "America/New_York"
            example.run
          end

          it "does not error" do
            expect { output }.to_not raise_error

            aggregate_failures do
              expect(stderr).to match("")
              expect(stderr).not_to match("ERROR")

              expect(stdout).to match("url")
              expect(stdout).to match("https://console.test.test/srv-lv426")

              expect(stdout).to match("token")
              expect(stdout).to match("<test-token-placeholder>")

              expect(stdout).to match("expires")
              expect(stdout).to match("2024-12-31T20:01")
            end
          end
        end
      end
    end
  end
end
