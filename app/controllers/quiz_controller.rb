class QuizController < ApplicationController
  include QuizHelper
  
  skip_before_action :verify_authenticity_token
  
  def resolve

    question = params[:question]
    level = params[:level]

    answer = q_resolve level, question
    
    render nothing: true
    
    uri = URI("http://pushkin-contest.ror.by/quiz")
    parameters = {
      answer: answer,
      token:  ENV['API_KEY'],
      task_id:  params[:id]
    }
    Net::HTTP.post_form(uri, parameters)

  end

end
