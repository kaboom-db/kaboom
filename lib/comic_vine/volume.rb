module ComicVine
  class Volume < Request
    attr_accessor :id

    def initialize(id:)
      @id = id
    end

    def retrieve = get

    private

    def endpoint
      "volume/4050-#{id}/"
    end

    def query_params
      {field_list: "id,aliases,api_detail_url,count_of_issues,date_last_updated,deck,description,image,name,publisher,site_detail_url,start_year,created_at,updated_at"}
    end
  end
end
