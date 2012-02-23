require "spec_helper"


describe "Server" do
  describe "server listing" do
    use_vcr_cassette('server_list')
    before(:each) do
      @servers = Brightbox::Server.find(:all)
    end

    it "should print server list" do
      output = capture_stdout {
        Brightbox.render_table(@servers, {})
      }
      output.should match(/active/)
    end
  end

  describe "Server show" do
    use_vcr_cassette('server_show')
    before do
      @servers = Brightbox::DetailedServer.find_or_call(["srv-egjzh"])
    end
    it "should show detailed attributes of a server" do
      output = capture_stdout {
        Brightbox.render_table(@servers,{:vertical => true})
      }
      output.should match("10.250.188.238")
      output.should match(/ram: 512/)
      output.should match(/disk: 20480/)
    end
  end

  describe "creating new servers" do
    it "should print error if account limit reached" do
      options = {
        :image_id => "img-4gqhs", :name => "medium servers",
        :zone_id => "", :user_data => nil, :flavor_id => "typ-qdiwq"
      }
      Brightbox::Server.expects(:create).raises(limit_exceeded_exception)
      error = nil
      begin
        Brightbox::Server.create(options)
      rescue Exception => e
        error = Brightbox::ErrorParser.new(e)
      end
      output = capture_stderr { error.pretty_print() }
      output.should match(/Account limit reached, please contact support for more information/i)
    end
  end

  describe "destroying servers" do
    use_vcr_cassette('server_destroy')
    it "should work" do
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

  describe "shutdown servers" do
    use_vcr_cassette("server_shutdown")
    it "should work" do
      type = Brightbox::Type.find_by_handle "nano"
      options = server_params("rspec_server_shutdown",type)
      server = (Brightbox::Server.create_servers 1, options).first
      lambda {
        server.shutdown
      }.should_not raise_error
    end
  end

  describe "stop servers" do
    use_vcr_cassette("server_stop")
    it "should work" do
      type = Brightbox::Type.find_by_handle "nano"
      options = server_params("rspec_server_stop",type)
      server = (Brightbox::Server.create_servers 1, options).first
      lambda {
        server.stop
      }.should_not raise_error
    end
  end

  describe "start server" do
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
