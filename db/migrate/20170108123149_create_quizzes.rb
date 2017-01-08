class CreateQuizzes < ActiveRecord::Migration[5.0]
  def change
    create_table :quizzes do |t|
      t.string :task
      t.integer :level
      t.string :answer

      t.timestamps
    end
  end
end
