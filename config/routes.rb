Rails.application.routes.draw do
  resources :poems
  
  post '/quiz', to: 'quiz#resolve'
  post '/registration', to: 'quiz#regisration'
end
