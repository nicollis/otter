Rails.application.routes.draw do
  root 'pages#home'
  get 'pages/home'

  get '/signup', to: 'users#new'
  post '/signup',  to: 'users#create'
  resources :users
  resources :account_activations, only: [:edit]

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destory'
end
