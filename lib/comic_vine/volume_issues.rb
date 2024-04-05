module ComicVine
  class VolumeIssues < Request
    attr_accessor :volume_id, :count_of_issues

    def initialize(volume_id:, count_of_issues:)
      @volume_id = volume_id
      @count_of_issues = count_of_issues
    end

    def retrieve
      @offset = 0
      pages = (count_of_issues / 100.0).ceil
      results = []
      pages.times do
        result = get
        @offset += 100
        next unless result.present?

        results << result[:results]
      end
      results.flatten.sort_by do |el|
        IssueNumberFormatter.format(el[:issue_number])
      end
    end

    private

    def endpoint
      "issues/"
    end

    def query_params
      {
        field_list: "aliases,api_detail_url,cover_date,date_last_updated,deck,description,id,image,issue_number,name,site_detail_url,store_date,volume",
        filter: "volume:#{volume_id}",
        offset: @offset
      }
    end
  end
end
