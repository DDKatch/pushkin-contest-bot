module QuizHelper
  def q_resolve(level, question)
    case level
    when 1 
      Line.joins(:poem).where(text: question).pluck("title").join   
    when 2
      line_ids = Word.where(text: question.split(/[^[[:word:]]]+/)).pluck("line_id")
      freq = line_ids.inject(Hash.new(0)) { |h,v| h[v] += 1; h  }
      line_id = line_ids.max_by { |v| freq[v]  }
      Line.joins(:poem).where(id: line_id).pluck("title").join
    when 3
      line_ids = Word.where(text: question.split(/[^[[:word:]]]+/)).pluck("line_id")
      freq = line_ids.inject(Hash.new(0)) { |h,v| h[v] += 1; h  }
      line_id = line_ids.max_by { |v| freq[v]  }  #TODO need take 2 max
      Line.joins(:poem).where(id: line_id).pluck("title").join
    when 4
      line_ids = Word.where(text: question.split(/[^[[:word:]]]+/)).pluck("line_id")
      freq = line_ids.inject(Hash.new(0)) { |h,v| h[v] += 1; h  }
      line_id = line_ids.max_by { |v| freq[v]  }  #TODO need take 3 max
      Line.joins(:poem).where(id: line_id).pluck("title").join
    when 5 # sql запрос может быть лучше
      words = question.split(/[^[[:word:]]]+/)
      line_ids = Word.where(text: question.split(/[^[[:word:]]]+/)).pluck("line_id")
      freq = line_ids.inject(Hash.new(0)) { |h,v| h[v] += 1; h  }
      line_id = line_ids.max_by { |v| freq[v]  } 
      all_words = Word.where(line_id: line_id).pluck("text")
      "#{all_words.reject{ |w| words.include? w }.join},#{words.reject{ |w| all_words.include? w  }.join}"
    end
  end
end
