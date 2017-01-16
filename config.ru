# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'



REQUEST_CATCHED = Time.now
Rails.logger.info "Request was catched: #{REQUEST_CATCHED}"
binding.pry

$redis = Redis.new

run Rails.application
