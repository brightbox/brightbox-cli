require "spec_helper"

describe Brightbox::Server do

  describe "#destroy" do
    use_vcr_cassette('server_destroy')

    it "should work" do
      #FIXME Spec never actually calls destroy, just checks output of creation!!
      type = Brightbox::Type.find_by_handle "nano"
      options = server_params("wow",type)
      @servers = Brightbox::Server.create_servers 1, options
      output = capture_stdout {
        Brightbox::render_table(@servers,:vertical => true)
      }
      output.should match("wow")
      output.should match("img-ymfuq")
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
