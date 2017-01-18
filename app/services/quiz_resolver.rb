module QuizResolver
 
  def normalize(string)
    string.mb_chars.squish!.to_s
  end
  
  def q_resolve(level, question)
    question = normalize(question) unless level == 3 || level == 4
    words = question.split(/[^[[:word:]]]+/)
    words.delete("WORD")
    letters = words.join.split("")
    query_part_of_letters = "'%#{letters.join("%' AND text like '%")}%'"
    query_part_of_words = "'#{words.join("%' AND text like '%")}%'"
    
    case level
    when 1 
      Line.find_title(question)
    when 2
      all_words = Line.find_line_with_skipped_word(query_part_of_words).join.split(/[^[[:word:]]]+/)
      "#{all_words.reject{ |w| words.include? w }.join}"   
    when 3..4
      q = []
      words = []
      query_part = []
      q = question.split(/\n/)
      res = []
      (level - 1).times do |i|
        words << q[i].split(/[^[[:word:]]]+/)
        words[i].delete("WORD")
        query_part << "'#{words[i].join("%' AND text like '%")}%'"
      end
      all_words = Line.find_changed_word_and_original(query_part).reverse
      all_words.map! {|l| l.split(/[^[[:word:]]]+/) }
      
      all_words.each_with_index do |a, i|
        res << a.reject{ |w| words[i].include? w }.join
      end 
      res.join(",")
    when 5 
      line_id = Word.fifth_level(words)
      all_words = Word.take_line_id(line_id)
      "#{all_words.reject{ |w| words.include? w }.join},#{words.reject{ |w| all_words.include? w  }.join}"
    when 6
      line_id = Line.find_text_with_correct_letters(query_part_of_letters)
      Line.find_correct_text(line_id)
    when 7
      temp = question.chars.sort.join.gsub(" ", "")
      Line.find_sorted_string(temp)   
    when 8
      temp = question.chars.sort.join.gsub(" ", "")
    end
  end
end
