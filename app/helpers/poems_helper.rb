module PoemsHelper
  def poem_lines(poem_id)
    Line.where(poem_id: poem_id).pluck("text")
  end
  
  def save_poem_lines(poem_id, poem_lines)
    Line.bulk_insert do |lines| # using gem bulk_insert
      poem_lines.map do |text|
        total_matches = 0
        text.chars.each do |symbol|
        end  
        lines.add({poem_id: poem_id, text: text, sorted_line: text.chars.sort.join.gsub(/[^0-9А-Яа-я]/i, '')})
      end
    end

    lines = Line.where(poem_id: poem_id)
    save_lines_words(lines)
    save_lines_symbols(lines)
    true
  end

  private
  
  def save_lines_words(lines)
    Word.bulk_insert do |words| # using gem bulk_insert
      lines.map do |line|
        line.text.split(/[^[[:word:]]]+/).delete_if(&:blank?).map do |text|
          words.add({line_id: line.id, text: text})
        end
      end
    end
  end

  def save_lines_symbols(lines)

  end
end
