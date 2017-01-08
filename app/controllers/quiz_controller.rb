class QuizController < ApplicationController
  include QuizHelper
  skip_before_action :verify_authenticity_token
  
	def resolve
    question = params[:question]
    level = params[:level]
    answer = q_resolve level, question
    
		RespondentWorker.perform_async(answer)  
		HistoryWriterWorker.perform_async(answer: answer, question: question, level: level)  
    
		render json: 'ok' 
	end
end
