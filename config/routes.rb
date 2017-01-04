Rails.application.routes.draw do
  resources :poems
  
  get '/show_poem/:id', to: 'quiz#show_poem'
  post '/quiz', to: 'quiz#resolve'
  post '/registration', to: 'quiz#regisration'
end
