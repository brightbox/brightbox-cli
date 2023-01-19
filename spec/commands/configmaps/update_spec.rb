require "spec_helper"
require "tempfile"

describe "brightbox configmaps update" do
  let(:output) { FauxIO.new { Brightbox.run(argv) } }
  let(:stdout) { output.stdout }
  let(:stderr) { output.stderr }

  before do
    config_from_contents(API_CLIENT_CONFIG_CONTENTS)

    stub_request(:post, "http://api.brightbox.localhost/token")
      .to_return(
        status: 200,
        body: JSON.dump(
          access_token: "ACCESS-TOKEN",
          refresh_token: "REFRESH_TOKEN"
        )
      )

    Brightbox.config.reauthenticate
  end

  context "without arguments" do
    let(:argv) { %w[configmaps update] }

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to eq("ERROR: You must specify the config map ID as the first argument\n")

      expect(stdout).to match("")
    end
  end

  context "with new name" do
    let(:argv) { %w[configmaps update --name New cfg-0932s] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/config_maps/cfg-0932s")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 200,
          body: {
            id: "cfg-0932s",
            name: "Old"
          }.to_json
        )
        .to_return(
          status: 200,
          body: {
            id: "cfg-0932s",
            name: "New",
            data: {}
          }.to_json
        )

      stub_request(:put, "http://api.brightbox.localhost/1.0/config_maps/cfg-0932s")
        .with(query: hash_including(account_id: "acc-12345"),
              body: {
                name: "New"
              })
        .to_return(
          status: 200,
          body: {
            id: "cfg-0932s",
            name: "New",
            data: {}
          }.to_json
        )
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to eq("Updating cfg-0932s\n")

      aggregate_failures do
        expect(stdout).to match("cfg-0932s")
        expect(stdout).to match("New")
      end
    end
  end

  context "with new map from 'data'" do
    let(:argv) { ["configmaps", "update", "--data", payload, "cfg-25hrt"] }

    context "with valid update" do
      let(:payload) { { new_key: "new value" }.to_json }

      before do
        stub_request(:get, "http://api.brightbox.localhost/1.0/config_maps/cfg-25hrt")
          .with(query: hash_including(account_id: "acc-12345"))
          .to_return(
            status: 200,
            body: {
              id: "cfg-25hrt",
              name: "",
              data: {
                old_key: "old value"
              }
            }.to_json
          )
          .to_return(
            status: 200,
            body: {
              id: "cfg-25hrt",
              name: "",
              data: {
                new_key: "new value"
              }
            }.to_json
          )

        stub_request(:put, "http://api.brightbox.localhost/1.0/config_maps/cfg-25hrt")
          .with(query: hash_including(account_id: "acc-12345"),
                body: {
                  data: {
                    new_key: "new value"
                  }
                })
          .to_return(
            status: 200,
            body: {
              id: "cfg-25hrt",
              name: "",
              data: {
                new_key: "new value"
              }
            }.to_json
          )
      end

      it "does not error" do
        expect { output }.to_not raise_error

        expect(stderr).to eq("Updating cfg-25hrt\n")

        aggregate_failures do
          expect(stdout).to match("cfg-25hrt")
        end
      end
    end

    context "with invalid update" do
      let(:payload) { "Not JSON!" }

      it "does not error" do
        expect { output }.to_not raise_error

        expect(stderr).to eq("ERROR: Config map data was not valid JSON\n")

        expect(stdout).to eq("")
      end
    end
  end

  context "with new map from 'data-file'" do
    context "when filename is used" do
      let(:argv) { ["configmaps", "update", "--data-file", data_file.path, "cfg-gr45a"] }
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
          stub_request(:get, "http://api.brightbox.localhost/1.0/config_maps/cfg-gr45a")
            .with(query: hash_including(account_id: "acc-12345"))
            .to_return(
              status: 200,
              body: {
                id: "cfg-gr45a",
                name: "",
                data: {
                  old_key: "old setting"
                }
              }.to_json
            )
            .to_return(
              status: 200,
              body: {
                id: "cfg-gr45a",
                name: "",
                data: {
                  new_key: "new setting"
                }
              }.to_json
            )

          stub_request(:put, "http://api.brightbox.localhost/1.0/config_maps/cfg-gr45a")
            .with(query: hash_including(account_id: "acc-12345"),
                  body: {
                    data: {
                      new_key: "new setting"
                    }
                  })
            .to_return(
              status: 200,
              body: {
                id: "cfg-gr45a",
                name: "",
                data: {
                  new_key: "new setting"
                }
              }.to_json
            )
        end

        it "does not error" do
          expect { output }.to_not raise_error

          expect(stderr).to eq("Updating cfg-gr45a\n")

          aggregate_failures do
            expect(stdout).to match("cfg-gr45a")
          end
        end

        context "with invalid update" do
          let(:payload) { "Not JSON!" }

          it "does not error" do
            expect { output }.to_not raise_error

            expect(stderr).to eq("ERROR: Config map data was not valid JSON\n")

            expect(stdout).to eq("")
          end
        end
      end
    end

    context "when '-' is used for STDIN" do
      let(:argv) { ["configmaps", "update", "--data-file", "-", "cfg-stdin"] }

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
          stub_request(:get, "http://api.brightbox.localhost/1.0/config_maps/cfg-stdin")
            .with(query: hash_including(account_id: "acc-12345"))
            .to_return(
              status: 200,
              body: {
                id: "cfg-stdin",
                name: "",
                data: {
                  use_stdin: true
                }
              }.to_json
            )
            .to_return(
              status: 200,
              body: {
                id: "cfg-stdin",
                name: "",
                data: {
                  use_stdin: true
                }
              }.to_json
            )

          stub_request(:put, "http://api.brightbox.localhost/1.0/config_maps/cfg-stdin")
            .with(query: hash_including(account_id: "acc-12345"),
                  body: {
                    data: {
                      use_stdin: true
                    }
                  })
            .to_return(
              status: 200,
              body: {
                id: "cfg-stdin",
                name: "",
                data: {
                  use_stdin: true
                }
              }.to_json
            )
        end

        it "does not error" do
          expect { output }.to_not raise_error

          expect(stderr).to eq("Updating cfg-stdin\n")

          aggregate_failures do
            expect(stdout).to match("cfg-stdin")
          end
        end

        context "with invalid update" do
          let(:payload) { "Not JSON!" }

          it "does not error" do
            expect { output }.to_not raise_error

            expect(stderr).to eq("ERROR: Config map data was not valid JSON\n")

            expect(stdout).to eq("")
          end
        end
      end
    end

    context "with mutually exclusive data options" do
      let(:argv) { ["configmaps", "update", "--data", payload, "--data-file", "-", "cfg-25hrt"] }
      let(:payload) { { new_key: "new value" }.to_json }

      context "with invalid update" do
        it "does not error" do
          expect { output }.to_not raise_error

          expect(stderr).to eq("ERROR: Config map data can only be passed by either 'data' or 'data-file'\n")

          expect(stdout).to eq("")
        end
      end
    end
  end
end
