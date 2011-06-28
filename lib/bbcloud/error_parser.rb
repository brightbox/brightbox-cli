module Brightbox
  class ErrorParser
    include Brightbox::Logging
    attr_accessor :socket_error

    def initialize(socket_error)
      @socket_error = socket_error
    end

    def pretty_print
      case socket_error
      when Excon::Errors::ServiceUnavailable
        error "Api currently unavailable"
      when Excon::Errors::Error
        parse_http_error(socket_error)
      else
        error "ERROR: #{socket_error}"
      end
    end

    def parse_http_error(e)
      if e.respond_to?(:response) and e.response.respond_to?(:body)
        json_response = JSON.parse(e.response.body) rescue {}
        if json_error = json_response['errors']
          error "ERROR: #{json_error.join(" ")}"
        else
          error "ERROR: #{e}"
        end
      else
        error "ERROR: #{e}"
      end
    end
  end
end
