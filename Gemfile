source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.8"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.5"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.6"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 5.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

# User authentication
gem "devise"

# Reusable, testable & encapsulated view components
gem "view_component"

# Run background jobs with Sidekiq
gem "sidekiq", "~> 7.2"

# Schedule sidekiq background jobs
gem "whenever", "~> 1.0", require: false

# Paginate ActiveRecord relations
gem "kaminari", "~> 1.2"

# For OpenSSL 3.0 in new Ubuntu versions
gem "net-ssh", "7.2.0"
gem "ed25519"
gem "bcrypt_pbkdf"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]

  # RSpec testing framework
  gem "rspec-rails"

  gem "shoulda-matchers"

  # Creating models easily
  gem "factory_bot_rails"

  # Style guide and linting for Ruby
  gem "standard"

  # Adds support for Capybara system testing and selenium driver
  gem "capybara", "~> 3.38"
  gem "selenium-webdriver"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Run specs on save
  gem "guard-rspec"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # Used for deploying
  gem "capistrano", "~> 3.10", require: false
  gem "capistrano-rails", "~> 1.6", require: false
  gem "capistrano-rvm", git: "https://github.com/capistrano/rvm.git"
  gem "capistrano3-puma", "~> 5.2"
end

group :test do
  # Stub API requests in specs
  gem "webmock", "~> 3.19"
end
