class SyncJob
  include Sidekiq::Job

  def perform
    trending_comics = Comic.trending.limit(20)
    trending_comics.each do |comic|
      comic.sync
    end
  end
end
