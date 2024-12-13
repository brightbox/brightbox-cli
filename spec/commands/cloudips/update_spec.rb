require "spec_helper"

describe "brightbox cloudips update" do
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

  context "" do
    let(:argv) { %w[cloudips update] }

    it "does not error" do
      expect { output }.to_not raise_error
    end
  end

  context "when name is updated" do
    let(:argv) { ["cloudips", "update", "--name=#{new_name}", "cip-12345"] }

    let(:json_response) do
      <<-EOS
      {
        "id":"cip-12345",
        "name":"#{new_name}"
      }
      EOS
    end

    context "--name 'New name'" do
      let(:new_name) { "New name" }
      let(:expected_args) { ["cip-12345", { :name => new_name }] }

      before do
        stub_request(:put, "http://api.brightbox.localhost/1.0/cloud_ips/cip-12345?account_id=acc-12345")
          .with(:headers => { "Content-Type" => "application/json" },
                :body => {
                  name: "New name"
                })
          .and_return(:status => 200, :body => json_response)

        stub_request(:get, "http://api.brightbox.localhost/1.0/cloud_ips/cip-12345?account_id=acc-12345")
          .with(:headers => { "Content-Type" => "application/json" })
          .and_return(:status => 200, :body => json_response)
      end

      it "puts new name in update" do
        expect(Brightbox::CloudIP.conn).to receive(:update_cloud_ip).with(*expected_args).and_call_original

        expect(stderr).to be_empty unless ENV["DEBUG"]

        expect(stdout).to include("cip-12345")
        expect(stdout).to include("New name")
      end
    end

    context "--name ''" do
      let(:new_name) { "" }
      let(:expected_args) { ["cip-12345", { :name => "" }] }

      before do
        stub_request(:put, "http://api.brightbox.localhost/1.0/cloud_ips/cip-12345?account_id=acc-12345")
          .with(:headers => { "Content-Type" => "application/json" },
                :body => hash_including("name" => ""))
          .and_return(:status => 200, :body => json_response)

        stub_request(:get, "http://api.brightbox.localhost/1.0/cloud_ips/cip-12345?account_id=acc-12345")
          .with(:headers => { "Content-Type" => "application/json" })
          .and_return(:status => 200, :body => json_response)
      end

      it "puts new name in update" do
        expect(Brightbox::CloudIP.conn).to receive(:update_cloud_ip).with(*expected_args).and_call_original
        expect(stderr).to be_empty unless ENV["DEBUG"]
        expect(stdout).to include("cip-12345")
      end
    end
  end

  context "--reverse-dns" do
    let(:argv) { ["cloudips", "update", "--reverse-dns", "domain.example", "cip-dfsa3"] }

    let(:json_response) do
      <<-EOS
      {
        "id":"cip-dfsa3",
        "reverse_dns":"domain.example"
      }
      EOS
    end

    before do
      stub_request(:put, "http://api.brightbox.localhost/1.0/cloud_ips/cip-dfsa3?account_id=acc-12345")
        .with(:headers => { "Content-Type" => "application/json" },
              :body => {
                reverse_dns: "domain.example"
              })
        .and_return(:status => 200, :body => json_response)

      stub_request(:get, "http://api.brightbox.localhost/1.0/cloud_ips/cip-dfsa3?account_id=acc-12345")
        .with(:headers => { "Content-Type" => "application/json" })
        .and_return(:status => 200, :body => json_response)
    end

    it "puts new name in update" do
      expect(stderr).to be_empty unless ENV["DEBUG"]
      expect(stdout).to include("cip-dfsa3")
      expect(stdout).to include("domain.example")
    end
  end

  context "--delete-reverse-dns" do
    let(:argv) { ["cloudips", "update", "--delete-reverse-dns", "cip-dfsa3"] }

    let(:json_response) do
      <<-EOS
      {
        "id":"cip-dfsa3",
        "reverse_dns":""
      }
      EOS
    end

    before do
      stub_request(:put, "http://api.brightbox.localhost/1.0/cloud_ips/cip-dfsa3?account_id=acc-12345")
        .with(:headers => { "Content-Type" => "application/json" },
              :body => {
                reverse_dns: ""
              })
        .and_return(:status => 200, :body => json_response)

      stub_request(:get, "http://api.brightbox.localhost/1.0/cloud_ips/cip-dfsa3?account_id=acc-12345")
        .with(:headers => { "Content-Type" => "application/json" })
        .and_return(:status => 200, :body => json_response)
    end

    it "puts new name in update" do
      expect(stderr).to be_empty unless ENV["DEBUG"]
      expect(stdout).to include("cip-dfsa3")
    end
  end

  context "--reverse-dns and --delete-reverse-dns options" do
    let(:argv) { ["cloudips", "update", "--reverse-dns", "domain.example", "--delete-reverse-dns", "cip-dfsa3"] }

    it "puts new name in update" do
      expect(stderr).to include("ERROR: You must either specify a reverse DNS record or --delete-reverse-dns\n")
      expect(stdout).to eq("")
    end
  end
end
