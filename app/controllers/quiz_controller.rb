class QuizController < ApplicationController
  include QuizHelper
  skip_before_action :verify_authenticity_token
  def resolve

    question = params[:question]
    level = params[:level]

    answer = q_resolve level, question
    
    render nothing: true
    


  end

end
