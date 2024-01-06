require "net/http"

module ComicVine
  class Request
    CREDENTIALS = Rails.application.credentials.dig(:comic_vine)
    BASE_URL = CREDENTIALS[:url]
    API_KEY = CREDENTIALS[:api_key]

    private

    def get
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true

      request = Net::HTTP::Get.new uri

      response = https.request(request)
      handle_response(response).presence if response.is_a?(Net::HTTPOK)
    end

    def endpoint
      ""
    end

    def query_params
      {}
    end

    def uri
      uri = URI("#{BASE_URL}#{endpoint}")
      uri.query = URI.encode_www_form(query_params.merge({api_key: API_KEY, format: format}))
      uri
    end

    def handle_response(response)
      JSON.parse(response.body, symbolize_names: true)
    end

    def format = "json"
  end
end
