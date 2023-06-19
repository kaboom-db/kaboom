RSpec.shared_context "stub ComicVine API request" do
  before do
    credentials = Rails.application.credentials.dig(:comic_vine)
    base_url = credentials[:url]
    api_key = credentials[:api_key]
    params = URI.encode_www_form(options.merge({api_key:, format: "json"})).to_s
    stub_request(:get, "#{base_url}#{endpoint}?#{params}").to_return(**response)
  end
end
