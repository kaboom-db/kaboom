module ComicVine
  class Issue < Request
    attr_accessor :id

    def initialize(id:)
      @id = id
    end

    def retrieve = get

    private

    def endpoint
      "issue/4000-#{id}/"
    end

    def query_params
      {field_list: "aliases,api_detail_url,cover_date,date_last_updated,deck,description,id,image,issue_number,name,site_detail_url,store_date,volume"}
    end
  end
end
