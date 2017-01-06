module QuizHelper
  def q_resolve(level, question)
    words = question.split(/[^[[:word:]]]+/)
    words.delete("WORD")
    letters = words.join.split("")
    query_part_of_letters = "'%#{letters.join("%' AND text like '%")}%'"
    query_part_of_words = "'#{words.join("%' AND text like '%")}%'"
    case level
      when 1 
        Line.joins(:poem).where(text: question).pluck("title").join   
      when 2
        line_id = Line.where("text like #{query_part_of_words}")
        Line.joins(:poem).where(id: line_id).pluck("title").join
      when 3
        line_id = Word.select("line_id").where(text: words).group(:line_id).having("count(*) > 2").order("count(*) desc").limit(1).pluck("line_id").join
        Line.joins(:poem).where(id: line_id).pluck("title").join
      when 4
        line_id = Word.select("line_id").where(text: words).group(:line_id).having("count(*) > 2").order("count(*) desc").limit(1).pluck("line_id").join
        Line.joins(:poem).where(id: line_id).pluck("title").join
      when 5 # sql запрос может быть лучше
        line_id = Word.select("line_id").where(text: words).group(:line_id).having("count(*) > 2").order("count(*) desc").limit(1).pluck("line_id").join
        all_words = Word.where(line_id: line_id).pluck("text")
        "#{all_words.reject{ |w| words.include? w }.join},#{words.reject{ |w| all_words.include? w  }.join}"
      when 6
        line_id = Line.where("text like #{query_part_of_letters}").limit(1)
        Line.joins(:poem).where(id: line_id).pluck("text").join
      end  
    
    query_part = "'#{words.join("%' AND text like '%")}%'"

    case level
    when 1 
      Line.joins(:poem).where(text: question).pluck("title").join   
    when 2
      line_id = Line.where("text like #{query_part}")
      Line.joins(:poem).where(id: line_id).pluck("title").join
    when 3
      line_id = Word.select("line_id").where(text: words).group(:line_id).having("count(*) > 2").order("count(*) desc").limit(1).pluck("line_id").join
      Line.joins(:poem).where(id: line_id).pluck("title").join
    when 4
      line_id = Word.select("line_id").where(text: words).group(:line_id).having("count(*) > 2").order("count(*) desc").limit(1).pluck("line_id").join
      Line.joins(:poem).where(id: line_id).pluck("title").join
    when 5 # sql запрос может быть лучше
      line_id = Word.select("line_id").where(text: words).group(:line_id).having("count(*) > 2").order("count(*) desc").limit(1).pluck("line_id").join
      all_words = Word.where(line_id: line_id).pluck("text")
      "#{all_words.reject{ |w| words.include? w }.join},#{words.reject{ |w| all_words.include? w  }.join}"
    end
  end
end
