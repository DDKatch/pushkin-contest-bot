include PoemsHelper

def initialize_database
  poems = JSON.load(IO.read(Rails.root.join('config', 'the-best-db.json')))
  
  poems.map do |poem|
    Poem.new(title: poem["title"]).save
    
    save_poem_lines(Poem.last.id, poem["lines"].reverse)
  end
end
  
puts "<-----Start initialize database----->"

initialize_database

puts "<-----End initialize database----->"
