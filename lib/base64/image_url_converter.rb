module Base64
  class ImageUrlConverter
    attr_reader :resource

    def initialize(resource)
      @resource = resource
    end

    def convert(attribute)
      begin
        image = resource.send(attribute)
      rescue
        image = nil
      end

      return "" unless image.present?

      uri = URI.parse(image)
      return "" unless uri.host.present?

      response = Net::HTTP.get_response(uri)
      return "" unless response.is_a?(Net::HTTPSuccess)

      image_data = response.body
      base64_image = Base64.strict_encode64(image_data)
      mime_type = response["Content-Type"]&.split("/")&.last || "jpg"

      "data:image/#{mime_type};base64,#{base64_image}"
    end
  end
end
