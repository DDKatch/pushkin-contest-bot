module QuizHelper
  def q_resolve(level, question)
    words = question.split(/[^[[:word:]]]+/)
    words.delete("WORD")
    
    query_part = "'#{words.join("%' AND text like '%")}%'"

    case level
    when 1 
      Line.joins(:poem).where(text: question).pluck("title").join   
    when 2
      all_words = Line.where("text like #{query_part}").pluck("text").join.split(/[^[[:word:]]]+/)
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

      all_words = Line.where("text like #{query_part.join("OR text like")}").pluck("text").reverse
      all_words.map! {|l| l.split(/[^[[:word:]]]+/) }
      
      all_words.each_with_index do |a, i|
        res << a.reject{ |w| words[i].include? w }.join
      end
      
      res.join(",")
    when 5 # sql запрос может быть лучше
      line_id = Word.select("line_id").where(text: words).group(:line_id).having("count(*) > 2").order("count(*) desc").limit(1).pluck("line_id").join
      all_words = Word.where(line_id: line_id).pluck("text")
      "#{all_words.reject{ |w| words.include? w }.join},#{words.reject{ |w| all_words.include? w  }.join}"
    end
  end
end
