module PoemsHelper
  def poem_lines(poem_id)
    Line.where(poem_id: poem_id).pluck("text")
  end
  
  def save_poem_lines(poem_id, poem_lines)
    Line.bulk_insert do |lines| # using gem bulk_insert
      poem_lines.reverse.map do |text|
        lines.add({poem_id: poem_id, text: text })
      end
    end
  end
end
