require "spec_helper"

describe Brightbox::ErrorParser do

  describe "#pretty_print" do
    let(:parser) { Brightbox::ErrorParser.new(error_to_parse) }

    context "when passed an Unauthorized error" do
      let(:msg) { double }
      let(:request) { double }
      let(:response) { double :body => json_response }

      let(:json_response) do
        <<-EOS
        {
          "error": "invalid_token",
          "error_description": "The OAuth token can not be found"
        }
        EOS
      end

      let(:error_to_parse) { Excon::Errors::Unauthorized.new(msg, request, response) }

      it "returns the response from the JSON" do
        expect(parser).to receive(:error).with("ERROR: invalid_token")
        parser.pretty_print
      end
    end

    context "when passed a ServiceUnavailable error" do
      let(:msg) { double }
      let(:request) { double }
      let(:response) { double }
      let(:error_to_parse) { Excon::Errors::ServiceUnavailable.new(msg, request, response) }

      it "returns a warning the API is missing" do
        expect(parser).to receive(:error).with("Api currently unavailable")
        parser.pretty_print
      end
    end

    context "when passed a non Excon error" do
      let(:msg) { "fnord is a required MuGuffin" }
      let(:error_to_parse) { ArgumentError.new(msg) }

      it "returns the error name" do
        expect(parser).to receive(:error).with("ERROR: #{msg}")
        parser.pretty_print
      end
    end
  end
end
