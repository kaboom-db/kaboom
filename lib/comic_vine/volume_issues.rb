module ComicVine
  class VolumeIssues < Request
    attr_accessor :volume_id

    def initialize(volume_id:)
      @volume_id = volume_id
    end

    def retrieve = get

    private

    def endpoint
      "issues/"
    end

    def query_params
      {
        field_list: "aliases,api_detail_url,cover_date,date_last_updated,deck,description,id,image,issue_number,name,site_detail_url,store_date,volume",
        filter: "volume:#{volume_id}"
      }
    end
  end
end
