
def normalize(string)
  spaces = string.mb_chars.gsub(/\A[[:space:]]*/, '')
  spaces = spaces.gsub(/[[:space:]]*\z/, '')
  res = spaces.gsub(/[\.\,\!\:\;\?\—]\z/, '')
  res.gsub(/[[:space:]]\z/, '').to_s
end


poems = JSON.load(IO.read(Rails.root.join('config', 'the-best-db.json')))

lines_array = poems.inject([]) do |lines, data|
  lines << data['lines'].inject([]) do |res_lines, line|
    res_lines << [normalize(line), data['title']]
  end
  lines.flatten!
end

LINES_TILES = Hash[*lines_array]
