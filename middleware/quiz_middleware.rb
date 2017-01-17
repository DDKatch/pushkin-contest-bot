class QuizMiddleware

  ADDR=URI("http://pushkin.rubyroidlabs.com/quiz") 
  
  def initialize app
    @app = app
  end

  def send_answer(parameters, time)
    Net::HTTP.post_form(ADDR, parameters)
    puts "Answer sended time: #{Time.now - time}\n\n"
  end

  def call env
    request_catched_time = Time.now 
    if env["REQUEST_METHOD"] == "POST" && env["REQUEST_PATH"] == "/quiz" # && env["HTTP_HOST"] == "185.143.172.139"   # for production
    # if env["REQUEST_METHOD"] == "POST" && env["REQUEST_PATH"] == "/quiz"
      params = JSON.parse(env["rack.input"].read)

      answer = q_resolve(params['level'], normalize(params['question']))
      
      elapsed_time = Time.now - request_catched_time 
      puts "\nAlgorithm time: #{elapsed_time} ms"   # better remove in production
      
      temp_time = Time.now

      parameters = {
        answer: answer,
        token: Rails.application.secrets[:api_key],
        task_id:  params['id']
      }
      elapsed_time = Time.now - temp_time 
      Thread.new{ send_answer(parameters, temp_time) }
      
      puts parameters
      puts "Request time: #{elapsed_time} ms"   # better remove in production
      [200, { 'Content-Type' => 'application/json' }, ['ok']]
    else
      @app.call env
    end
  end

  private
  def normalize(string)
    spaces = string.mb_chars.gsub(/\A[[:space:]]*/, '')
    spaces = spaces.gsub(/[[:space:]]*\z/, '')
    res = spaces.to_s
    res.gsub(/[[:space:]]\z/, '').to_s
  end

  def q_resolve(level, question)
   
    case level
    when 1
      # binding.pry 
      LINES_TILES[question]  
    end
  end
end
