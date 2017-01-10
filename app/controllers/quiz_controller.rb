class QuizController < ApplicationController
  include QuizResolver

  skip_before_action :verify_authenticity_token
  
  ADDR=URI("http://pushkin.rubyroidlabs.com/quiz") 
  
  def resolve
    question = params[:question]
    level = params[:level]
    answer = q_resolve level, question
    
		render json: 'ok' 
 
    parameters = {
      answer: answer,
      token: Rails.application.secrets[:api_key],
      task_id:  params[:id]
    }

    Net::HTTP.post_form(ADDR, parameters)

    History.new(answer: answer, question: question, level: level).save
  end
end
