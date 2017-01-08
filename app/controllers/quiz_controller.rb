class QuizController < ApplicationController
  include QuizHelper
  skip_before_action :verify_authenticity_token
  def resolve
 @question = params[:question]
    @task_id = params[:id]
     @level = params[:level]
     @level = 2 if @level.nil? # registration
      @answer = q_resolve @level, @question
    
 if @task_id.nil? 
       @response = {
         answer: @answer # registration
       }
     else
       @response = {
         answer: @answer,
         token: @token,
         task_id: @task_id
       }
       
     end   
render json: @response

  end

end
