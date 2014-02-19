require "spec_helper"
require "fog/brightbox/models/compute/database_server"

describe "brightbox sql instances" do
  describe "update" do
    let(:output) { FauxIO.new { Brightbox.run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    context "--default-maintenance" do
      let(:sql_instance) { double }
      let(:argv) { %w(sql instances update --default-maintenance dbs-12345) }
      let(:expected_args) { { :maintenance_weekday => nil, :maintenance_hour => nil } }

      it "uses default maintenance window settings" do
        expect(Brightbox::DatabaseServer).to receive(:find).and_return(sql_instance)
        expect(sql_instance).to receive(:update).with(expected_args)
        expect(stdout).to eql("")
      end
    end
  end
end
