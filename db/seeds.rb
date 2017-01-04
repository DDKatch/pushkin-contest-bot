# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
include PoemsHelper


URL = "http://rupoem.ru/pushkin/all.aspx"

def parse_poems_from_url(url)
  doc = Nokogiri::HTML(open(url), nil, "windows-1251")
  poems = []

  doc.css('h2.poemtitle').each do |link|
    poems << {title: link.content, text: ""}
  end

  doc.css('div.poem-text').each_with_index do |link, i|
    poems[i][:text] = link.content
  end
  poems
end

def init_db(poems)
  poems = parse_poems_from_url URL

  poems.map do |poem|
    @poem = Poem.new title: poem[:title]
    @poem_lines = poem[:text].split "\r\n"# poem lines
    
    @poem.save
    save_poem_lines(Poem.last.id, @poem_lines.reverse)
  end
end
  
puts "start parse"
poems = parse_poems_from_url URL
puts "end parse\nstart initialize database"
init_db poems
puts "end initialize database"
