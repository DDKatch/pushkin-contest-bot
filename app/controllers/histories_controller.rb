class HistoriesController < ApplicationController
	def index
		@histories = History.all	
	end
	
	def new
		@history = History.new	
	end
	
	def create
		@history = History.new(history_params)
	end
	
	private	
	
	def history_params
		params.require(:history).permit(:question, :answer, :level)	
	end
end
