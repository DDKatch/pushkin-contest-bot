module QuizHelper
  def q_resolve(level, question)
    case level
    when 1 
      Line.joins(:poem).where(text: question).pluck("title").join   
    end
  end
end
