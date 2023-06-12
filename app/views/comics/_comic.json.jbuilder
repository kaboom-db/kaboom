json.extract! comic, :id, :aliases, :api_detail_url, :issue_count, :summary, :description, :cv_id, :cover_image, :name, :start_year, :created_at, :updated_at
json.url comic_url(comic, format: :json)
