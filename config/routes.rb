Rails.application.routes.draw do
  root 'pages#home'
  get 'pages/home'

  get '/signup', to: 'users#new'
  post '/signup',  to: 'users#create'
  get '/api/users', to: 'users#query'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_reset, only: [:new, :create, :edit, :update]

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destory'

  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]

  # API
  resources :graphql, only: :create
end
