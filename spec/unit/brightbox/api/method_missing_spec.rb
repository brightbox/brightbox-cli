require "ostruct"
require "spec_helper"

RSpec.describe Brightbox::Api, "#method_missing" do
  let(:fog_model) { Fog::Model.new }
  let(:identifier) { "api-12345" }

  before do
    allow(fog_model).to receive(:id).and_return(identifier)
    allow(fog_model).to receive(:attributes).and_return({})
  end

  context "when initialised with a fog model" do
    subject(:instance) { described_class.new(fog_model) }

    context "with a top level method" do
      it do
        expect(instance.to_s).to eq(identifier)
      end
    end

    context "with a delegated method" do
      let(:method_name) { :attributes }

      it do
        expect(instance.attributes).to eq({})
      end
    end

    context "with unknown method" do
      it do
        expect { instance.onions }.to raise_error(NoMethodError)
      end
    end
  end

  context "when initialised with an identifier string" do
    subject(:instance) { described_class.new(identifier) }

    before do
      allow(Brightbox::Api).to receive(:find).with(identifier).and_return(fog_model)
    end

    context "with a top level method" do
      it do
        expect(instance.to_s).to eq(identifier)
      end
    end

    context "with a delegated method" do
      let(:method_name) { :attributes }

      it do
        expect(instance.attributes).to eq({})
      end
    end

    context "with unknown method" do
      it do
        expect { instance.onions }.to raise_error(NoMethodError)
      end
    end
  end
end
