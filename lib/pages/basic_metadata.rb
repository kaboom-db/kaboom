module Pages
  class BasicMetadata < Metadata
    attr_reader :title, :description, :image

    def initialize(title:, description:, image:)
      @title = title
      @description = description
      @image = image
    end
  end
end
