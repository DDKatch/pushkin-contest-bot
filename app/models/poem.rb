class Poem < ApplicationRecord
  has_many :lines, dependent: :destroy 
 
  def lines
    Line.where(poem_id: self.id).pluck("text").join("\r\n")
  end

end
