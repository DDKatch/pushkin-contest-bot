Rails.application.routes.draw do
  root to: "histories#index"
  
  resources :poems
  resources :histories, only: %w{index}
  
  post '/quiz', to: 'quiz#resolve'
  post '/registration', to: 'quiz#regisration'
end
