class Word < ApplicationRecord
  belongs_to :line
   scope :fifth_level, -> (words){select("line_id").where(text: words).group(:line_id).having("count(*) > 2").order("count(*) desc").limit(1).pluck("line_id").join}
   scope :take_line_id, -> (line_id){where(line_id: line_id).pluck("text")}
end
