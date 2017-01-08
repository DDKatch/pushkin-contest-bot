class RespondentWorker
  include Sidekiq::Worker

	ADDR=URI("http://pushkin-contest.ror.by/")	
  
  def perform(answer)
  
    @http = Net::HTTP.new(ADDR.host)

    # retryable(tries: 3) do
      data = { answer: answer, token: Rails.application.secrets[:api_key], task_id: params[:id]}
      @http.post('/quiz', data.to_json, {'Content-Type' =>'application/json'})
    # end

  end
end
