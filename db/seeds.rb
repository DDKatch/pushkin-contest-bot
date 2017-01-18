include PoemsHelper

def normalize_db(string)
  string.mb_chars.squish!.to_s
  string.gsub(/[\.\,\!\:\;\?\—]\z/, '')
end

def initialize_database
  poems = JSON.load(IO.read(Rails.root.join('config', 'the-best-db.json')))
  poems.map do |poem|
    Poem.new(title: poem["title"]).save
   
    lines = poem["lines"].inject([]) { |rows, line| rows << normalize_db(line) }

    lines.reverse!
    save_poem_lines(Poem.last.id, lines)
  end

end
  
puts "<-----Start initialize database----->"

initialize_database

puts "<-----End initialize database----->"
