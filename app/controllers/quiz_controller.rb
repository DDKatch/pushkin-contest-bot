class QuizController < ApplicationController
  include QuizHelper
  skip_before_action :verify_authenticity_token
  
	ADDR=URI("http://pushkin-contest.ror.by/")	

	def resolve
    
    question = params[:question]
    level = params[:level]
    answer = q_resolve level, question
    
    @http = Net::HTTP.new(ADDR.host)
		# send_answer(answer)
    
	 	History.new(answer: answer, question: question, level: level).save
    
		render json: 'ok' 
	end

  def send_answer(answer)
    retryable(tries: 3) do
      data = { answer: answer, token: Rails.application.secrets[:api_key], task_id: params[:id]}
      @http.post('/quiz', data.to_json, {'Content-Type' =>'application/json'})
    end
  end

end
