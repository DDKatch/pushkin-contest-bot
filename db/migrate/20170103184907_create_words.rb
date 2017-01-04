class CreateWords < ActiveRecord::Migration[5.0]
  def change
    create_table :words do |t|
      t.string :text
      t.references :line, foreign_key: true
    end
  end
end
