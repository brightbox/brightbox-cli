module Brightbox
  class ErrorParser
    include Brightbox::Logging
    attr_accessor :socket_error, :token_error

    def initialize(socket_error)
      @socket_error = socket_error
      @token_error = update_token()
    end

    def update_token
      return false unless socket_error.is_a?(Excon::Errors::Unauthorized)
      debug "Refused access token: #{$config.oauth_token}"
      $config.update_refresh_token
    rescue
      false
    ensure
      $config.debug_tokens
    end

    def pretty_print
      return if token_error
      case socket_error
      when Excon::Errors::ServiceUnavailable
        error "Api currently unavailable"
      else
        parse_http_error(socket_error)
      end
    end

    def parse_http_error(e)
      if e.respond_to?(:response) and e.response.respond_to?(:body)
        json_response = JSON.parse(e.response.body) rescue {}
        extract_response_from_json(json_response,e)
      else
        error "ERROR: #{e}"
      end
    end

    def extract_response_from_json(error_json,e)
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
