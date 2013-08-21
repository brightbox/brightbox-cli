require "spec_helper"

describe Brightbox::BBConfig do
  let(:expected_token) { random_token }

  before do
    @config = config_from_contents(contents)
  end

  describe "#refresh_token" do
    context "when value has been set" do
      let(:contents) { "" }

      it "returns set value" do
        @config.refresh_token = expected_token
        expect(@config.refresh_token).to eql(expected_token)
      end
    end

    context "when cached value exists" do
      let(:contents) do
        <<-EOS
        [app-12345]
        client_id = app-12345
        refresh_token = #{expected_token}
        EOS
      end

      it "returns value from config" do
        expect(@config.refresh_token).to eql(expected_token)
      end
    end

    context "when cache files does not exist" do
      let(:contents) do
        <<-EOS
        [app-12345]
        EOS
      end

      it "returns nil" do
        expect(@config.refresh_token).to be_nil
      end
    end
  end
end
