require "multi_json"

module Brightbox
  class ErrorParser
    include Brightbox::Logging
    attr_accessor :socket_error, :token_error

    def initialize(socket_error)
      @socket_error = socket_error
    end

    def pretty_print
      case socket_error
      when Excon::Errors::ServiceUnavailable
        error "Api currently unavailable"
      else
        parse_http_error(socket_error)
      end
    end

    def parse_http_error(e)
      if e.respond_to?(:response) && e.response.respond_to?(:body)
        begin
          json_response = MultiJson.load(e.response.body)
          extract_response_from_json(json_response, e)
        rescue
          {}
        end
      else
        error "ERROR: #{e}"
      end
    end

    def extract_response_from_json(error_json, e)
      json_error = error_json['errors'] || error_json['error']
      if json_error && !json_error.empty?
        error_string = Array(json_error).join(" ")
        error "ERROR: #{error_string}"
      else
        error "ERROR: #{e}"
      end
    end
  end
end
