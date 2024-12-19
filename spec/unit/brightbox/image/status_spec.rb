require "spec_helper"

RSpec.describe Brightbox::Image, "#status" do
  subject(:image) { Brightbox::Image.new(fog_model) }

  let(:fog_model) do
    double(
      "Fog::Compute::Brightbox::Image",
      id: "img-12345",
      attributes: {
        "id": "img-12345",
        "status": status,
        "public": is_public
      },
      public: is_public
    )
  end
  let(:is_public) { false }

  context "when the image is pending" do
    let(:status) { "pending" }

    it "returns 'pending'" do
      expect(image.status).to eq("pending")
    end
  end

  context "when the image is available" do
    let(:status) { "available" }

    context "with public visibility" do
      let(:is_public) { true }

      it "returns 'public'" do
        expect(image.status).to eq("public")
      end
    end

    context "without public visibility" do
      let(:is_public) { false }

      it "returns 'private'" do
        expect(image.status).to eq("private")
      end
    end
  end

  context "when the image is deprecated" do
    let(:status) { "deprecated" }

    context "with public visibility" do
      let(:is_public) { true }

      it "returns 'deprecated'" do
        expect(image.status).to eq("deprecated")
      end
    end

    context "without public visibility" do
      let(:is_public) { false }

      it "returns 'private'" do
        expect(image.status).to eq("private")
      end
    end
  end
end
