include PoemsHelper

def normalize(string)
  spaces = string.mb_chars.gsub(/\A[[:space:]]*\z/, '')
  spaces.gsub(/[\.\,\!\:\;\?]+\z/, '').to_s
end

def initialize_database
  poems = JSON.load(IO.read(Rails.root.join('config', 'the-best-db.json')))
  poems.map do |poem|
    Poem.new(title: poem["title"]).save
   
    lines = poem["lines"].inject([]) { |rows, line| rows << normalize(line) }

    lines.reverse!
    save_poem_lines(Poem.last.id, lines)
  end

end
  
puts "<-----Start initialize database----->"

initialize_database

puts "<-----End initialize database----->"
