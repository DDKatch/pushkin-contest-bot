module QuizHelper
  def q_resolve(level, question)
    words = question.split(/[^[[:word:]]]+/)
    words.delete("WORD")
    letters = words.join.split("")
    query_part_of_letters = "'%#{letters.join("%' AND text like '%")}%'"
    query_part_of_words = "'#{words.join("%' AND text like '%")}%'"
    answers = init_answers(level)
    case level
    when 1 
      if answers[question] == nil          
        answers[question] = Line.find_title(question)
        answers.to_json
        $redis.set("1", answers)
      end
      answers[question]
    when 2
      if answers[question] == nil  
        all_words = Line.find_line_with_skipped_word(query_part_of_words).join.split(/[^[[:word:]]]+/)
        answers[question] = "#{all_words.reject{ |w| words.include? w }.join}"   
        answers.to_json
        $redis.set("2", answers)
      end
      answers[question]      
    when 3..4
      answers = init_answers(level)
      if answers[question] == nil
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
        answers[question] = "#{res.join(",")}"
        $redis.set("#{level},", answers.to_json)
      end
      answers[question]
    when 5 # sql запрос может быть лучше
      if answers[question] == nil
        line_id = Word.fifth_level(words)
        all_words = Word.take_line_id(line_id)
        answers[question] = "#{all_words.reject{ |w| words.include? w }.join},#{words.reject{ |w| all_words.include? w  }.join}"
        $redis.set("#{level},", answers.to_json)
      end
      answers[question]
    when 6
      if answers[question] == nil
        line_id = Line.find_text_with_correct_letters(query_part_of_letters)
        answers[question] = Line.find_correct_text(line_id)
        $redis.set("#{level},", answers.to_json)
      end  
      answers[question] 
    when 7
      if answers[question] == nil
        temp = question.chars.sort.join.gsub(" ", "")
        answers[question] = Line.find_sorted_string(temp)   
        binding.pry 
      end
      answers[question]
    end
  end

  private
  
  def init_answers(level)
    answers = {}
    if $redis.get("#{level}") == nil
      $redis.set("#{level}", {}.to_json)
    else
      answers = eval($redis.get("#{level}"))
    end
    answers
  end
end
