class AddSortedStringToLines < ActiveRecord::Migration[5.0]
  def change
    add_column :lines, :sorted_line, :string
  end
end
