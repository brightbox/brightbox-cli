require "spec_helper"

describe "Firewall policies" do
  before do
    skip "Spec is grabbing global state (from config) and breaking other specs"
  end

  describe "update" do
    let(:output) { FauxIO.new { Brightbox.run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    context "when no identifier is given", vcr: true do
      let(:argv) { %w(firewall-policies update) }

      it "prints error to STDERR" do
        expect(stderr).to include("ERROR: You must specify the firewall-policy-id to update")
      end
    end

    context "when the policy does not exist", vcr: true do
      let(:argv) { %w(firewall-policies update -n missing fwp-12345) }

      it "prints error to STDERR" do
        expect(stderr).to include("ERROR: Resource not found using supplied identifier")
      end
    end

    context "when the policy exists" do
      before do
        @policy = Brightbox::FirewallPolicy.create({})
      end

      after do
        # FIXME: All specs are pending, why is this trying to run against nil?
        @policy.destroy if @policy
      end

      context "when new name is given", vcr: true do
        let(:name) { "fnord" }
        let(:argv) { ["firewall-policies", "update", "-n", name, @policy.id] }

        it "returns resource with updated name" do
          expect(stdout).to include(name)
        end

        it "has updated the resource" do
          skip "Fails out of sequence"
          expect { output }.to_not raise_error
          @updated_policy = Brightbox::FirewallPolicy.find(@policy.id)
          expect(@updated_policy.attributes[:name]).to eql(name)
        end
      end

      context "when new description is given", vcr: true do
        let(:description) { "New policy description" }
        let(:argv) { ["firewall-policies", "update", "-d", description, @policy.id] }

        it "returns resource table (excludes description)" do
          expect(stdout).to include(@policy.id)
        end

        it "has updated the resource" do
          skip "Fails out of sequence"
          expect { output }.to_not raise_error
          @updated_policy = Brightbox::FirewallPolicy.find(@policy.id)
          expect(@updated_policy.attributes[:description]).to eql(description)
        end
      end

      context "when no options are given", vcr: true do
        let(:argv) { ["firewall-policies", "update", @policy.id] }

        it "prints error to STDERR" do
          expect(stderr).to include("ERROR: No options were given so unable to update")
        end
      end
    end
  end
end
