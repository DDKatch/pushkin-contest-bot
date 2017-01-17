# This file is used by Rack-based servers to start the application.
require_relative 'config/environment'
# require_relative 'middleware/quiz_middleware'
# require_relative 'middleware/quiz_resolver_middleware'

$redis = Redis.new

# use QuizMiddleware
# use QuizResolverMiddleware
run Rails.application
