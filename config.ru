# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

$redis = Redis.new

run Rails.application
