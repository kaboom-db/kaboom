db = {
  "development" => 0,
  "production" => 0,
  # Avoid test runs interfering with development (15 is highest database index)
  "test" => 15
}.fetch(Rails.env.to_s)

sidekiq_config = {url: ENV.fetch("REDIS_URL", "redis://localhost:6379/1"), db:}

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end

Sidekiq.default_job_options = {"backtrace" => true}
