require "vcr"

VCR.configure do |vcr|
  vcr.cassette_library_dir = File.join(File.dirname(__FILE__), "../cassettes")
  vcr.allow_http_connections_when_no_cassette = false
  vcr.hook_into :webmock

  vcr.configure_rspec_metadata!
  vcr.default_cassette_options = {
    :record => :none,
    # :record => :new_episodes,
    :match_requests_on => %i[method path body],
    :update_content_length_header => true
  }

  # Gives lots of clues about how VCR is running
  # vcr.debug_logger = $stderr

  vcr.before_record do |interaction|
    host = URI.parse(interaction.request.uri).host
    interaction.request.uri.gsub!(host, "api.brightbox.localhost")
  end
end
