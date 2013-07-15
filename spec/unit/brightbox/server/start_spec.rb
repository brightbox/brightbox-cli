require "spec_helper"

describe Brightbox::Server do

  describe "#start" do
    use_vcr_cassette("server_start")

    it "should work" do
      type = Brightbox::Type.find_by_handle "nano"
      options = server_params("rspec_server_start",type)
      server = (Brightbox::Server.create_servers 1, options).first
      lambda {
        server.stop
        server.start()
      }.should_not raise_error
    end
  end

  def server_params(name,type)
    {
      :image_id      => "img-ymfuq",
      :name          => name,
      :zone_id       => nil.to_s,
      :flavor_id     => type.id,
      :user_data     => nil
    }
  end
end
