Rails.application.routes.draw do
  resources :poems
  resources :histories
  root to: "histories#index"
  post '/quiz', to: 'quiz#resolve'
  post '/registration', to: 'quiz#regisration'
end
