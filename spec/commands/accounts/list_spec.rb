require "spec_helper"

describe "brightbox accounts" do

  describe "list" do
    let(:output) { FauxIO.new { Brightbox.run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    context "", :vcr do
      let(:argv) { %w(accounts list) }

      it "does not error" do
        expect { output }.to_not raise_error
      end
    end

    context "(when no tokens)", :vcr do
      let(:password) { default_test_password }

      let(:argv) { %w(accounts list) }

      before do
        config_from_contents(USER_APP_CONFIG_CONTENTS)
        mock_password_entry
      end

      it "does not report invalid token errors" do
        expect(stderr).to_not include("ERROR")
      end

      it "reports they were updated" do
        expect(stderr).to include("Your API credentials have been updated, please re-run your command")
      end
    end

    context "(when no tokens and password incorrect)", :vcr do
      let(:password) { "wrong" }

      let(:argv) { %w(accounts list) }

      before do
        config_from_contents(USER_APP_CONFIG_CONTENTS)
        mock_password_entry(password)
      end

      it "does not report invalid token errors" do
        expect(stderr).to_not include("ERROR")
      end

      it "reports unable to authenticate" do
        expect(stderr).to include("Unable to authenticate with supplied details")
      end
    end

    context "(when access token expired)", :vcr do
      let(:password) { default_test_password }

      let(:argv) { %w(accounts list) }

      before do
        config = config_from_contents(USER_APP_CONFIG_CONTENTS)

        # Setup in the VCR recordings as the access token is expired
        cache_access_token(config, "08f204123bb2fc400521577445df9d1d212da42e")
        cache_refresh_token(config, "a05c73351bbbc8d3abba9cf175733aec22a5cb71")
      end

      it "does not report invalid token errors" do
        expect(stderr).to_not include("ERROR: invalid_token")
      end
    end

    context "(when both tokens expired)", :vcr do
      let(:password) { default_test_password }

      let(:argv) { %w(accounts list) }

      before do
        config = config_from_contents(USER_APP_CONFIG_CONTENTS)

        # Setup in the VCR recordings as both are expired
        cache_access_token(config, "23fff1fa28e267fb9ac060d24f278ae71b77ac53")
        cache_refresh_token(config, "b57a7c633a65614b74cc29839ccfade8e64e696d")
        mock_password_entry
      end

      it "does not report invalid token errors" do
        expect(stderr).to_not include("ERROR: invalid_token")
      end
    end

    context "(when invalid tokens)", :vcr do
      let(:password) { default_test_password }

      let(:argv) { %w(accounts list) }

      before do
        config = config_from_contents(USER_APP_CONFIG_CONTENTS)
        cache_access_token(config, "23b0e1da3d19e10a85247fffe0e488435b1c5861")
        cache_refresh_token(config, "c08bd7973ddf8493d878b22fe69c1044bbb3abb1")
        mock_password_entry
      end

      it "does not report invalid token errors" do
        expect(stderr).to_not include("ERROR: invalid_token")
      end
    end
  end
end
