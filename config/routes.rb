Rails.application.routes.draw do
  root 'lobby#index'

  resources :games, only: [:create, :index]

  get '/name' => 'name#new'
  post '/name' => 'name#create'

end
