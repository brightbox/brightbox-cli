require "spec_helper"

describe "brightbox images" do

  describe "list" do
    let(:output) { FauxIO.new { Brightbox.run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    before do
      config_from_contents(USER_APP_CONFIG_CONTENTS)

      stub_request(:post, "http://api.brightbox.dev/token").
        to_return(status: 200, body: JSON.dump(access_token: "ACCESS-TOKEN", refresh_token: "REFRESH-TOKEN"))

      image_listing_json = JSON.dump([
        {
          id: "img-test1",
          name: "Official image",
          status: "available",
          official: true,
          public: true,
          source_type: "upload",
          owner: "acc-99999"
        },
        {
          id: "img-test2",
          name: "Public image",
          status: "available",
          official: false,
          public: true,
          source_type: "upload",
          owner: "acc-abcde"
        },
        {
          id: "img-test3",
          name: "Customer image",
          status: "available",
          official: false,
          public: false,
          source_type: "upload",
          owner: "acc-12345"
        },
        {
          id: "img-test4",
          name: "Customer snapshot",
          status: "available",
          official: false,
          public: false,
          source_type: "snapshot",
          owner: "acc-12345"
        },
        {
          id: "img-test5",
          name: "Customer deleting image",
          status: "deleting",
          official: false,
          public: false,
          source_type: "upload",
          owner: "acc-12345"
        }
      ])

      stub_request(:get, "http://api.brightbox.dev/1.0/images?account_id=acc-12345").
        with(headers: { "Authorization" => "Bearer ACCESS-TOKEN" }).
        to_return(status: 200, body: image_listing_json)

      stub_request(:get, "http://api.brightbox.dev/1.0/account?account_id=acc-12345&nested=false").
        with(headers: { "Authorization" => "Bearer ACCESS-TOKEN" }).
        to_return(status: 200, body: JSON.dump({ id: "acc-12345" }))
    end

    context "when default listing" do
      let(:argv) { %w(images list) }

      it "does not error" do
        expect(stderr).not_to include("ERROR")

        expect(stdout).to include("img-test1")
        expect(stdout).not_to include("img-test2")
        expect(stdout).to include("img-test3")
        expect(stdout).to include("img-test4")
        expect(stdout).to include("img-test5")
      end
    end

    context "when listing all cases" do
      let(:argv) { %w(images list --show-all) }

      it "does not error" do
        expect(stderr).not_to include("ERROR")

        expect(stdout).to include("img-test1")
        expect(stdout).to include("img-test2")
        expect(stdout).to include("img-test3")
        expect(stdout).to include("img-test4")
        expect(stdout).to include("img-test5")
      end
    end

    context "when filtering by status" do
      let(:argv) { %w(images list --status deleting) }

      it "does not error" do
        expect(stderr).not_to include("ERROR")

        expect(stdout).not_to include("img-test1")
        expect(stdout).not_to include("img-test2")
        expect(stdout).not_to include("img-test3")
        expect(stdout).not_to include("img-test4")
        expect(stdout).to include("img-test5")
      end
    end

    context "when filtering by type" do
      let(:argv) { %w(images list --type snapshot) }

      it "does not error" do
        expect(stderr).not_to include("ERROR")

        expect(stdout).not_to include("img-test1")
        expect(stdout).not_to include("img-test2")
        expect(stdout).not_to include("img-test3")
        expect(stdout).to include("img-test4")
        expect(stdout).not_to include("img-test5")
      end
    end

    context "when filtering by own account ID" do
      let(:argv) { %w(images list --account acc-12345) }

      it "does not error" do
        expect(stderr).not_to include("ERROR")

        expect(stdout).not_to include("img-test1")
        expect(stdout).not_to include("img-test2")
        expect(stdout).to include("img-test3")
        expect(stdout).to include("img-test4")
        expect(stdout).to include("img-test5")
      end
    end

    context "when filter by own account ID and all" do
      let(:argv) { %w(images list --account acc-12345 --show-all) }

      it "does not error" do
        expect(stderr).not_to include("ERROR")

        expect(stdout).not_to include("img-test1")
        expect(stdout).not_to include("img-test2")
        expect(stdout).to include("img-test3")
        expect(stdout).to include("img-test4")
        expect(stdout).to include("img-test5")
      end
    end
  end
end
