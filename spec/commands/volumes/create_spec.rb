require "spec_helper"

describe "brightbox volumes create" do
  include VolumeHelpers

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
    let(:argv) { %w[volumes create] }

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to match("ERROR: An 'image' or 'fs-type' option must be passed")

      expect(stdout).to eq("")
    end
  end

  context "with mutually exclusive options" do
    let(:argv) { %w[volumes create --image img-12345 --fs-type ext4] }

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to match("ERROR: An 'image' and 'fs-type' can not be passed together")

      expect(stdout).to eq("")
    end
  end

  context "with image identifier" do
    let(:argv) { %w[volumes create --image img-12345] }

    before do
      stub_request(:post, "http://api.brightbox.localhost/1.0/volumes")
        .with(headers: { "Content-Type" => "application/json" },
              query: hash_including(account_id: "acc-12345"),
              body: {
                delete_with_server: false,
                encrypted: false,
                image: "img-12345"
              })
        .to_return(
          status: 202,
          body: volume_response(
            id: "vol-12345",
            storage_type: "network",
            size: 10_240,
            status: "detached"
          )
        )
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).not_to match("ERROR")

      aggregate_failures do
        expect(stdout).to match("id.*type.*size.*status.*server.*boot")

        expect(stdout).to match("vol-12345")
        expect(stdout).to match("network")
        expect(stdout).to match("10240")
        expect(stdout).to match("detached")
        expect(stdout).to match("false")
      end
    end
  end

  context "with image and size" do
    let(:argv) { %w[volumes create --image img-12345 --size 20480] }

    before do
      stub_request(:post, "http://api.brightbox.localhost/1.0/volumes")
        .with(headers: { "Content-Type" => "application/json" },
              query: hash_including(account_id: "acc-12345"),
              body: {
                delete_with_server: false,
                encrypted: false,
                image: "img-12345",
                size: 20_480
              })
        .to_return(
          status: 202,
          body: volume_response(
            id: "vol-12345",
            storage_type: "network",
            size: 20_480,
            status: "detached"
          )
        )
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).not_to match("ERROR")

      aggregate_failures do
        expect(stdout).to match("id.*type.*size.*status.*server.*boot")

        expect(stdout).to match("vol-12345")
        expect(stdout).to match("network")
        expect(stdout).to match("20480")
        expect(stdout).to match("detached")
        expect(stdout).to match("false")
      end
    end
  end

  context "with filesystem type" do
    let(:argv) { %w[volumes create --fs-type ext4] }

    before do
      stub_request(:post, "http://api.brightbox.localhost/1.0/volumes")
        .with(headers: { "Content-Type" => "application/json" },
              query: hash_including(account_id: "acc-12345"),
              body: {
                delete_with_server: false,
                encrypted: false,
                filesystem_type: "ext4"
              })
        .to_return(
          status: 202,
          body: volume_response(
            id: "vol-12345",
            storage_type: "network",
            size: 10_240,
            status: "detached"
          )
        )
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).not_to match("ERROR")

      aggregate_failures do
        expect(stdout).to match("id.*type.*size.*status.*server.*boot")

        expect(stdout).to match("vol-12345")
        expect(stdout).to match("network")
        expect(stdout).to match("10240")
        expect(stdout).to match("detached")
        expect(stdout).to match("false")
      end
    end
  end

  context "with most options" do
          let(:argv) do
            %w[volumes create --fs-label fnord --fs-type ext4 --delete-with-server --encrypted --name Nom -d Test --serial 12345 -s 20480]
          end

    before do
      stub_request(:post, "http://api.brightbox.localhost/1.0/volumes")
        .with(headers: { "Content-Type" => "application/json" },
              query: hash_including(account_id: "acc-12345"),
              body: {
                delete_with_server: true,
                description: "Test",
                encrypted: true,
                filesystem_label: "fnord",
                filesystem_type: "ext4",
                name: "Nom",
                serial: "12345",
                size: 20_480
              })
        .to_return(
          status: 202,
          body: volume_response(
            id: "vol-43251",
            name: "Nom",
            boot: false,
            description: "Test",
            encrypted: true,
            serial: "12345",
            storage_type: "network",
            size: 20_480,
            status: "detached"
          )
        )
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).not_to match("ERROR")

      aggregate_failures do
        expect(stdout).to match("id.*type.*size.*status.*server.*boot")

        expect(stdout).to match("vol-43251")
        expect(stdout).to match("network")
        expect(stdout).to match("20480")
        expect(stdout).to match("detached")
        expect(stdout).to match("false")
      end
    end
  end
end
