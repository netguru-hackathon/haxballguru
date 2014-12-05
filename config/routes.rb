Rails.application.routes.draw do
  root 'lobby#index'

  resources :games, only: [:create, :index] do
    collection do
      get '/:name' => 'games#game'
    end
  end

  get '/name' => 'name#new'
  post '/name' => 'name#create'

end
