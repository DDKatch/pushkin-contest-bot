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
    
    add_to_history(answer, question, level)
  end
  def add_to_history(answer, question, level)
    new_to_dashboard = History.create
    new_to_dashboard.answer = answer
    new_to_dashboard.question = question
    new_to_dashboard.level = level
    new_to_dashboard.save
  end
end
