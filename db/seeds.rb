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
  j_poems = JSON.parse(File.read(Rails.root.join('config', 'the-best-db.json')))

  @poems = j_poems.flat_map{|name, lines| {title: name, lines: lines} }

  @poems.uniq! {|e| e[:lines]}

  File.open("the-best-db.json","w") do |f|
    f.write(@poems.to_json)
  end

  @poems.map do |poem|
    @poem = Poem.new title: poem[:title]
    @poem_lines = poem[:lines].map!{ |v| normalize(v) }
    
    @poem.save
    save_poem_lines(Poem.last.id, @poem_lines.reverse)
  end
end
  
puts "start parse"
poems = parse_poems_from_url URL
puts "end parse\nstart initialize database"
init_db poems
puts "end initialize database"
