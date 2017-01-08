class QuizController < ApplicationController
  include QuizHelper
  
  skip_before_action :verify_authenticity_token
  
  def resolve

    question = params[:question]
    level = params[:level]

    answer = q_resolve level, question
   
    render nothing: true, :status => 200, :content_type => 'application/json'
    
    uri = URI("http://pushkin-contest.ror.by/quiz")
    
    parameters = {
      answer: answer,
      token:  Rails.application.secrets[:api_key],
      task_id:  params[:id]
    }
    
    binding.remote_pry
    
    Net::HTTP.new(uri, parameters).post_form

  end

end
