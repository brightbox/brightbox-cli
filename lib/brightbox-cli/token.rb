require "json"

module Brightbox
  class Token
    def self.show(config, options)
      new(config, options)
    end

    attr_accessor :config, :options

    def initialize(config, options = {})
      @config = config
      @options = options
    end

    def access_token
      config.access_token
    end

    def format(output = :text)
      output = output.to_sym

      case output
      when :curl
        curl_output
      when :json
        json_output
      when :token
        token_output
      else
        text_output
      end
    end

    def refresh_token
      config.refresh_token
    end

    private

    def api_url
      base_url = URI(config.to_fog[:brightbox_api_url]).to_s
      URI.join(base_url, "/1.0/").to_s
    end

    def curl_output
      "curl -H 'Authorization: Bearer #{access_token}' #{api_url} "
    end

    def json_output
      JSON.dump(token_data)
    end

    def text_output
      token_data.map do |key, value|
        "#{key.to_s.rjust(16)}: #{value}"
      end.join("\n")
    end

    def token_data
      data = {
        access_token: access_token,
        token_type: "Bearer"
      }
      data[:refresh_token] = refresh_token if refresh_token
      data.sort.to_h
    end

    def token_output
      access_token
    end
  end
end
