require "spec_helper"

describe Brightbox::BBConfig do
  let(:expected_token) { random_token }

  before do
    contents = <<-EOS
    [app-12345]
    client_id = app-12345
    EOS
    @config = config_from_contents(contents)
  end

  describe "#access_token" do
    context "when value has been set" do
      it "returns set value" do
        @config.access_token = expected_token
        expect(@config.access_token).to eql(expected_token)
      end
    end

    context "when cache file exists" do
      it "returns value from file" do
        File.open(@config.oauth_token_filename, "w") do |f|
          f.write expected_token
        end

        expect(@config.access_token).to eql(expected_token)
      end
    end

    context "when cache files does not exist" do
      it "returns nil" do
        expect(@config.access_token).to be_nil
      end
    end
  end
end
