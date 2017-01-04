class CreateLineSymbols < ActiveRecord::Migration[5.0]
  def change
    create_table :line_symbols do |t|
      t.string :text
      t.integer :count
      t.references :line, foreign_key: true
    end
  end
end
