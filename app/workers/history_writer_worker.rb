class HistoryWriterWorker
  include Sidekiq::Worker

  def perform(history)
	 	binding.pry
    History.new(history).save  
  end
end
