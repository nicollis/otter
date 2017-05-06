Rails.application.routes.draw do
  get '/signup', to: 'users#new'

  get 'pages/home'
  root 'pages#home'
end
