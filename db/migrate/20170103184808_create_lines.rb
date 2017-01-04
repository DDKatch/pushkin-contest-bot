class CreateLines < ActiveRecord::Migration[5.0]
  def change
    create_table :lines do |t|
      t.string :text
      t.references :poem, foreign_key: true
    end
  end
end
