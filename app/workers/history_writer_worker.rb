class HistoryWriterWorker
  include Sidekiq::Worker

  def perform(history)
    History.new(history).save  
  end
end
