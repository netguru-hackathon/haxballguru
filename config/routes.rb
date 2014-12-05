Rails.application.routes.draw do
  root 'lobby#index'

  resources :games, only: [:create]
end
