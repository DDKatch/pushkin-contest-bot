require 'json'
module QuizHelper
  def q_resolve(level, question)
    words = question.split(/[^[[:word:]]]+/)
    words.delete("WORD")
    letters = words.join.split("")
    query_part_of_letters = "'%#{letters.join("%' AND text like '%")}%'"
    query_part_of_words = "'#{words.join("%' AND text like '%")}%'"
    case level
    when 1 
      answers = init_answers(1)
      if answers[question] == nil          
        answers[question] = Line.joins(:poem).where(text: question).pluck("title").join
        answers.to_json
        $redis.set("1", answers)
      end
      answers[question]
    when 2
      answers = init_answers(2)
      if answers[question] == nil  
        all_words = Line.where("text like #{query_part_of_words}").pluck("text").join.split(/[^[[:word:]]]+/) 
        answers[question] = "#{all_words.reject{ |w| words.include? w }.join}"   
        answers.to_json
        $redis.set("2", answers)
      end
      answers[question]      
    when 2..4
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
        all_words = Line.where("text like #{query_part.join("OR text like")}").pluck("text").reverse
        all_words.map! {|l| l.split(/[^[[:word:]]]+/) }
        
        all_words.each_with_index do |a, i|
          res << a.reject{ |w| words[i].include? w }.join
        end
        
        answers[question] = "#{res.join(",")}"
      end
      answers[question]
    when 5 # sql запрос может быть лучше
      line_id = Word.select("line_id").where(text: words).group(:line_id).having("count(*) > 2").order("count(*) desc").limit(1).pluck("line_id").join
      all_words = Word.where(line_id: line_id).pluck("text")
      "#{all_words.reject{ |w| words.include? w }.join},#{words.reject{ |w| all_words.include? w  }.join}"
    when 6
      line_id = Line.where("text like #{query_part_of_letters}").limit(1)
      Line.joins(:poem).where(id: line_id).pluck("text").join
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
