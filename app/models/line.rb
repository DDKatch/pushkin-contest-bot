class Line < ApplicationRecord
  belongs_to :poem, dependent: :destroy
  
  scope :find_title, -> (question){ joins(:poem).where(text: question).limit(1).pluck("title").join }
  scope :find_line_with_skipped_word, -> (query_part_of_words){ where("text like #{ query_part_of_words }").pluck("text") }
  scope :find_changed_word_and_original, -> (query_part){ where("text like #{ query_part.join("OR text like") }").pluck("text") }
  scope :find_text_with_correct_letters, -> (query_part_of_letters){ where("text like #{ query_part_of_letters }").limit(1) }
  scope :find_correct_text, -> (line_id){ joins(:poem).where(id: line_id).pluck("text").join }
  scope :find_sorted_string, -> (question){joins(:poem).where(sorted_line: question).pluck("text").join}
end
