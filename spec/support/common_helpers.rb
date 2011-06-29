module CommonHelpers
  def capture_stdout(&block)
    original_stdout = $stdout
    $stdout = fake = StringIO.new
    begin
      yield
    ensure
      $stdout = original_stdout
    end
    fake.string
  end

def capture_stderr(&block)
    original_stderr = $stderr
    $stderr = fake = StringIO.new
    begin
      yield
    ensure
      $stderr = original_stderr
    end
    fake.string
  end

  def limit_exceeded_exception(request = {})
    request_options = {
      :headers=> {
        "Content-Type"=>"application/json", "Authorization"=>"OAuth 864b21f13485a7f2de49593f627213075e8eb046",
        "Host"=>"api.gb1.brightbox.com:443", "Content-Length"=>71
      },
      :host=>"api.gb1.brightbox.com", :mock=>false, :path=>"/1.0/servers",
      :port=>"443", :query=>nil, :scheme=>"https",
      :expects=>[202],
      :method=>"POST",
      :body=>"{\"image\":\"img-4gqhs\",\"server_type\":\"typ-qdiwq\",\"name\":\"medium servers\"}"
    }

    response = Excon::Response.new(
      :body => "{\"error_name\":\"account_limit_reached\",\"errors\":[\"Account limit reached, please contact support for more information\"]}",
      :status => 403,
      :headers => {
        "Date"=>"Tue, 28 Jun 2011 08:07:21 GMT", "Server"=>"Apache", "Cache-Control"=>"no-cache", "Access-Control-Allow-Origin"=>"*", "Access-Control-Allow-Headers"=>"Authorization", "Content-Length"=>"118", "Status"=>"403", "Content-Type"=>"application/json; charset=utf-8"
      }
    )

    Excon::Errors.status_error(request_options.merge(request),response)
  end
end
