class QuizMiddleware
  def initialize app
    @app = app
  end

  def call env
    request_catched_time = Time.now
    Rails.logger.info "Request was catched: #{request_catched_time}"
    binding.pry
  end
end
