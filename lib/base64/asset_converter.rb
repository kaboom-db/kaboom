module Base64
  class AssetConverter
    attr_reader :asset_path, :mime_type

    def initialize(asset_path, mime_type)
      @asset_path = asset_path
      @mime_type = mime_type
    end

    def convert
      file_path = Rails.root.join("app", "assets", *asset_path)

      begin
        file_content = File.read(file_path)
      rescue
        file_content = nil
      end
      return "" unless file_content

      base64_content = Base64.strict_encode64(file_content)

      "data:#{mime_type};base64,#{base64_content}"
    end
  end
end
