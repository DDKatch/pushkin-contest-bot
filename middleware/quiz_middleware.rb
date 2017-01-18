class QuizMiddleware
  
  def normalize_db(string)
    string.mb_chars.squish!.to_s
    string.gsub(/[\.\,\!\:\;\?\—]\z/, '')
  end

  def initialize app
    @token = Rails.application.secrets[:api_key]
    @address = URI("http://pushkin.rubyroidlabs.com/quiz") 

    @poems = JSON.load(IO.read(Rails.root.join('config', 'the-best-db.json')))

    lines_titles_array = @poems.inject([]) do |lines, data|
      lines << data['lines'].inject([]) do |res_lines, line|
        res_lines << [normalize_db(line), data['title']]
      end
      lines.flatten!
    end

    @lines_titles= Hash[*lines_titles_array]

    @lines = @poems.inject([]) do |lines, data|
      lines << data['lines'].inject([]) do |res_lines, line|
        res_lines << normalize_db(line)
      end
    end.flatten!

    # pry
    
    @app = app
  end

  def send_answer(answer, task_id)
    Net::HTTP.post_form(@address, {answer: answer, token: @token, task_id: task_id})
  end

  def call env
    request_catched_time = Time.now
    if env["REQUEST_METHOD"] == "POST" && env["REQUEST_PATH"] == "/quiz" # && env["HTTP_HOST"] == "185.143.172.139"   # for production
    # if env["REQUEST_METHOD"] == "POST" && env["REQUEST_PATH"] == "/quiz"
      # puts "Time: #{request_catched_time}"
      puts params = JSON.parse(env["rack.input"].read)

      answer = resolve(params['level'], normalize(params['question']))
      puts "Answer: #{answer}, Id: #{params['id']}"
      # elapsed_time = Time.now.usec - request_catched_time 
      # puts "\nAlgorithm time: #{elapsed_time} ms"   # better remove in production
      
      # temp_time = Time.now
      # elapsed_time = Time.now - temp_time 
      
      send_answer(answer, params['id'])

      puts "Elapsed time: #{Time.now - request_catched_time} sec\n\n"
      
      [200, { 'Content-Type' => 'application/json' }, ['ok']]
    else
      @app.call env
    end
  end

  private
  def normalize(string)
    string.mb_chars.squish!.to_s
  end

  def resolve(level, question)
    case level
    when 1
      @lines_titles[question] 
    when 2
      question.gsub!('%WORD%', '([А-Яа-я]+)')
      @lines.map do |line| 
        word = line[%r{\A#{question }\z}, 1]
        return word unless word.nil?
      end
    end
  end
end
