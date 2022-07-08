require "spec_helper"

describe Brightbox::BBConfig do
  describe "#refresh_token_filename" do
    context "when using a custom directory" do
      before do
        @client_name = "fnord"

        Dir.mktmpdir do |dir|
          @config = Brightbox::BBConfig.new :directory => dir
          @config.client_name = "fnord"
          @cached_token_filename = File.join(dir, "fnord.refresh_token")
        end
      end

      it "returns a path to the filename" do
        expect(@config.refresh_token_filename).to eql(@cached_token_filename)
      end

      it "includes the client name" do
        filename = File.basename(@config.refresh_token_filename)
        expect(filename).to include(@client_name)
      end
    end
  end
end
