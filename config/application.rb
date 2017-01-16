require_relative 'boot'
require_relative './../app/middleware/quiz_middleware.rb'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PushkinResolver
  class Application < Rails::Application
    # config.middleware.use QuizMiddleware
    config.cache_store = :redis_store, "redis://localhost:6379/0/cache", { expires_in: 90.minutes }
  end
end
