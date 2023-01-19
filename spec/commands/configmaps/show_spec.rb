require "spec_helper"

describe "brightbox configmaps show" do
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
    let(:argv) { %w[configmaps show] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/config_maps")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 200,
          body: config_maps_response
        )
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to eq("")

      aggregate_failures do
        expect(stdout).to match("id: cfg-12345")
        expect(stdout).to match("id: cfg-abcde")
      end
    end
  end

  context "with identifier" do
    let(:argv) { %w[configmaps show cfg-lk432] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/config_maps/cfg-lk432")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 200,
          body: {
            id: "cfg-lk432",
            name: "Staging Config Example",
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
        expect(stdout).to match("id: cfg-lk432")
        expect(stdout).to match("name: Staging Config Example")
      end
    end
  end

  context "with '--data' output" do
    context "with multiple IDs" do
      let(:argv) { %w[configmaps show --data cfg-m543s cfg-klds4] }

      it "does not error" do
        expect { output }.to_not raise_error

        expect(stderr).to eq("ERROR: You can only access data for a single config map at a time\n")

        expect(stdout).to eq("")
      end
    end

    context "without '--format'" do
      let(:argv) { %w[configmaps show --data cfg-xd3d4] }

      before do
        stub_request(:get, "http://api.brightbox.localhost/1.0/config_maps/cfg-xd3d4")
          .with(query: hash_including(account_id: "acc-12345"))
          .to_return(
            status: 200,
            body: {
              id: "cfg-lk432",
              name: "Staging Config Example",
              data: {
                key: "value",
                name: "key name"
              }
            }.to_json
          )
      end

      it "does not error" do
        expect { output }.to_not raise_error

        expect(stderr).not_to match("ERROR")

        expect(stdout).to eq(%({"key":"value","name":"key name"}\n))
      end
    end

    context "with '--format json'" do
      let(:argv) { %w[configmaps show --data --format json cfg-xd3d4] }

      before do
        stub_request(:get, "http://api.brightbox.localhost/1.0/config_maps/cfg-xd3d4")
          .with(query: hash_including(account_id: "acc-12345"))
          .to_return(
            status: 200,
            body: {
              id: "cfg-lk432",
              name: "Staging Config Example",
              data: {
                key: "value",
                name: "key name"
              }
            }.to_json
          )
      end

      it "does not error" do
        expect { output }.to_not raise_error

        expect(stderr).to eq("")

        expect(stdout).to eq(%({"key":"value","name":"key name"}\n))
      end
    end

    context "without '--format text'" do
      let(:argv) { %w[configmaps show --data --format text cfg-xd3d4] }

      before do
        stub_request(:get, "http://api.brightbox.localhost/1.0/config_maps/cfg-xd3d4")
          .with(query: hash_including(account_id: "acc-12345"))
          .to_return(
            status: 200,
            body: {
              id: "cfg-lk432",
              name: "Staging Config Example",
              data: {
                key: "value",
                name: "key name"
              }
            }.to_json
          )
      end

      it "does not error" do
        expect { output }.to_not raise_error

        expect(stderr).not_to match("ERROR")

        aggregate_failures do
          expect(stdout).to match("^             key: value")
          expect(stdout).to match("^            name: key name")
        end
      end
    end
  end

  context "with '--format' without 'data'" do
    let(:argv) { %w[configmaps show --format json cfg-lk432] }

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to match("ERROR: The 'format' option can only be used with 'data'")

      expect(stdout).to eq("")
    end
  end

  context "with simple output" do
    let(:argv) { %w[--simple configmaps show cfg-lk432] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/config_maps/cfg-lk432")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 200,
          body: {
            id: "cfg-lk432",
            name: "Staging Config Example",
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
        expect(stdout).to match("^id\tcfg-lk432$")
        expect(stdout).to match("^name\tStaging Config Example$")
      end
    end
  end

  def config_maps_response
    [
      {
        id: "cfg-12345",
        name: "Test 12345",
        data: {}
      },
      {
        id: "cfg-abcde",
        name: "Test ABCDE",
        data: {
          key: "value"
        }
      }
    ].to_json
  end
end
