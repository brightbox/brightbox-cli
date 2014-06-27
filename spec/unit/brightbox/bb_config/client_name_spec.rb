require "spec_helper"

describe Brightbox::BBConfig do

  describe "#client_name" do
    context "when passed as an option" do
      before do
        @client_name = "app-kl342"
        @config = Brightbox::BBConfig.new(:client_name => @client_name)
      end

      it "returns the passed version" do
        expect(@config.client_name).to eql(@client_name)
      end
    end

    context "when config file contains a default client" do
      before do
        @client_name = "app-b3n5b"
        contents = <<-EOS
        [core]
        default_client = #{@client_name}
        EOS
        @config = config_from_contents(contents)
      end

      it "returns the configured default" do
        expect(@config.client_name).to eql(@client_name)
      end
    end

    context "when config file contains only one client" do
      before do
        @client_name = "cli-sdio2"
        contents = <<-EOS
        [core]
        default_client = #{@client_name}

        [app-12345]
        client_id = app-12345
        EOS
        @config = config_from_contents(contents)
      end

      it "returns the name of that client" do
        expect(@config.client_name).to eql(@client_name)
      end
    end

    context "when config contains no default and multiple clients" do
      before do
        contents = <<-EOS
        [app-first]
        client_id = app-first

        [cli-12345]
        client_id = cli-12345
        EOS
        @tmp_config = TmpConfig.new(contents)
      end

      after do
        @tmp_config.close
      end

      context "and force_default_config is on" do
        before do
          config_opts = {
            :directory => @tmp_config.path,
            :force_default_config => true
          }
          @config = Brightbox::BBConfig.new(config_opts)
        end

        it "raises an error" do
          expect do
            @config.client_name
          end.to raise_error(Brightbox::BBConfigError, "You must specify a default client using brightbox config client_default")
        end
      end

      context "and force_default_config is off" do
        before do
          config_opts = {
            :directory => @tmp_config.path,
            :force_default_config => false
          }
          @config = Brightbox::BBConfig.new(config_opts)
        end

        it "returns first client" do
          expect(@config.client_name).to be_nil
        end
      end
    end
  end
end
