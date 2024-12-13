require "spec_helper"

describe "brightbox configmaps create" do
  let(:output) { FauxIO.new { Brightbox.run(argv) } }
  let(:stdout) { output.stdout }
  let(:stderr) { output.stderr }

  let(:token) { SecureRandom.hex }

  before do
    config_from_contents(API_CLIENT_CONFIG_CONTENTS)

    stub_request(:post, "http://api.brightbox.localhost/token")
      .to_return(status: 200, body: JSON.dump(access_token: token))

    Brightbox.config.reauthenticate
  end

  context "without options" do
    let(:argv) { %w[configmaps create] }

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to match("Config map data is required as 'data' option")

      expect(stdout).to eq("")
    end
  end

  context "with 'name' and 'data'" do
    let(:argv) { ["configmaps", "create", "--name", "tester", "--data", payload] }
    let(:payload) { { key: "value" }.to_json }

    before do
      stub_request(:post, "http://api.brightbox.localhost/1.0/config_maps")
        .with(headers: { "Content-Type" => "application/json" },
              query: hash_including(account_id: "acc-12345"),
              body: {
                name: "tester",
                data: {
                  key: "value"
                }
              })
        .to_return(
          status: 200,
          body: {
            id: "cfg-lk342",
            name: "tester",
            data: {
              key: "value"
            }
          }.to_json
        )
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).not_to match("ERROR")

      aggregate_failures do
        expect(stdout).to match("id.*name")

        expect(stdout).to match("cfg-lk342")
      end
    end
  end

  context "with 'data'" do
    let(:argv) { ["configmaps", "create", "--data", payload] }
    let(:payload) { { key: "value" }.to_json }

    before do
      stub_request(:post, "http://api.brightbox.localhost/1.0/config_maps")
        .with(headers: { "Content-Type" => "application/json" },
              query: hash_including(account_id: "acc-12345"),
              body: {
                data: {
                  key: "value"
                }
              }.to_json)
        .to_return(
          status: 200,
          body: {
            id: "cfg-lk342",
            data: {
              key: "value"
            }
          }.to_json
        )
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).not_to match("ERROR")

      aggregate_failures do
        expect(stdout).to match("id.*name")

        expect(stdout).to match("cfg-lk342")
      end
    end

    context "with invalid update" do
      let(:payload) { "Not JSON!" }

      it "does not error" do
        expect { output }.to_not raise_error

        expect(stderr).to include("ERROR: Config map data was not valid JSON\n")

        expect(stdout).to eq("")
      end
    end
  end

  context "with new map from 'data-file'" do
    context "when filename is used" do
      let(:argv) { ["configmaps", "create", "--data-file", data_file.path] }
      let(:data_file) { Tempfile.open("config_map_test_data") }

      around do |example|
        data_file.write(payload)
        data_file.close

        example.run

        data_file.unlink
      end

      context "with valid update" do
        let(:payload) { { new_key: "new setting" }.to_json }

        before do
          stub_request(:post, "http://api.brightbox.localhost/1.0/config_maps")
            .with(query: hash_including(account_id: "acc-12345"),
                  body: {
                    data: {
                      new_key: "new setting"
                    }
                  })
            .to_return(
              status: 200,
              body: {
                id: "cfg-s432l",
                name: "",
                data: {
                  new_key: "new setting"
                }
              }.to_json
            )
        end

        it "does not error" do
          expect { output }.to_not raise_error

          expect(stderr).to include("Creating config map\n")

          aggregate_failures do
            expect(stdout).to match("cfg-s432l")
          end
        end

        context "with invalid update" do
          let(:payload) { "Not JSON!" }

          it "does not error" do
            expect { output }.to_not raise_error

            expect(stderr).to include("ERROR: Config map data was not valid JSON\n")

            expect(stdout).to eq("")
          end
        end
      end
    end
  end

  context "when '-' is used for STDIN" do
    let(:argv) { ["configmaps", "create", "--data-file", "-", "cfg-stdin"] }

    before do
      stdin_data = StringIO.new
      stdin_data.puts(payload)
      stdin_data.rewind

      $stdin = stdin_data
    end

    after do
      $stdin = STDIN
    end

    context "with valid update" do
      let(:payload) { { use_stdin: true }.to_json }

      before do
        stub_request(:post, "http://api.brightbox.localhost/1.0/config_maps")
          .with(query: hash_including(account_id: "acc-12345"),
                body: {
                  data: {
                    use_stdin: true
                  }
                })
          .to_return(
            status: 200,
            body: {
              id: "cfg-mj53s",
              name: "",
              data: {
                use_stdin: true
              }
            }.to_json
          )
      end

      it "does not error" do
        expect { output }.to_not raise_error

        expect(stderr).to include("Creating config map\n")

        aggregate_failures do
          expect(stdout).to match("cfg-mj53s")
        end
      end

      context "with invalid update" do
        let(:payload) { "Not JSON!" }

        it "does not error" do
          expect { output }.to_not raise_error

          expect(stderr).to include("ERROR: Config map data was not valid JSON\n")

          expect(stdout).to eq("")
        end
      end
    end
  end

  context "with mutually exclusive data options" do
    let(:argv) { ["configmaps", "create", "--data", payload, "--data-file", "-"] }
    let(:payload) { { new_key: "new value" }.to_json }

    context "with invalid update" do
      it "does not error" do
        expect { output }.to_not raise_error

        expect(stderr).to include("ERROR: Config map data can only be passed by either 'data' or 'data-file'\n")

        expect(stdout).to eq("")
      end
    end
  end
end
