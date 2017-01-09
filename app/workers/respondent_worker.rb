class RespondentWorker
  include Sidekiq::Worker

  ADDR=URI("http://pushkin.rubyroidlabs.com/quiz")	
  
  def perform(answer, task_id)
  
    @http = Net::HTTP.new(ADDR.host)

    data = { answer: answer, token: Rails.application.secrets[:api_key], task_id: task_id}
    @http.post('/quiz', data.to_json, {'Content-Type' =>'application/json'})
  end
end
