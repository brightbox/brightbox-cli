require "spec_helper"

describe "brightbox configmaps destroy" do
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
    let(:argv) { %w[configmaps destroy] }

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to include("ERROR: You must specify config map IDs as arguments\n")

      expect(stdout).to match("")
    end
  end

  context "with one argument" do
    let(:argv) { %w[configmaps destroy cfg-xdwe2] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/config_maps/cfg-xdwe2")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 200,
          body: {
            id: "cfg-xdwe2"
          }.to_json
        )
        .to_return(
          status: 200,
          body: {
            id: "cfg-xdwe2"
          }.to_json
        )

      stub_request(:delete, "http://api.brightbox.localhost/1.0/config_maps/cfg-xdwe2")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 202,
          body: {
            id: "cfg-xdwe2"
          }.to_json
        )
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to match("Destroying cfg-xdwe2\n")

      expect(stdout).to eq("")
    end
  end

  context "with multiple arguments" do
    let(:argv) { %w[configmaps destroy cfg-12ds4 cfg-vf567] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/config_maps/cfg-12ds4")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 200,
          body: {
            id: "cfg-12ds4"
          }.to_json
        )
        .to_return(
          status: 200,
          body: {
            id: "cfg-12ds4"
          }.to_json
        )

      stub_request(:delete, "http://api.brightbox.localhost/1.0/config_maps/cfg-12ds4")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 200,
          body: {
            id: "cfg-12ds4"
          }.to_json
        )

      stub_request(:get, "http://api.brightbox.localhost/1.0/config_maps/cfg-vf567")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 200,
          body: {
            id: "cfg-vf567"
          }.to_json
        )
        .to_return(
          status: 200,
          body: {
            id: "cfg-vf567"
          }.to_json
        )

      stub_request(:delete, "http://api.brightbox.localhost/1.0/config_maps/cfg-vf567")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 200,
          body: {
            id: "cfg-vf567"
          }.to_json
        )
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to match("Destroying cfg-12ds4\n")
      expect(stderr).to match("Destroying cfg-vf567\n")

      expect(stdout).to eq("")
    end
  end

  context "with unknown argument" do
    let(:argv) { %w[configmaps destroy cfg-lk234] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/config_maps/cfg-lk234")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 404,
          body: ""
        )
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to match("Couldn't find cfg-lk234\n")

      expect(stdout).to eq("")
    end
  end
end
