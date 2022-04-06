Rails.application.routes.draw do
  root "sessions#new"

  get '/home' => 'organizations#index'
  get '/home/new' => 'organizations#new'
  post '/home/new_organization' => 'organizations#create'

  get '/login' => 'sessions#new'

  post 'login' => "sessions#create"

  delete '/logout' => "sessions#destroy"

  resources :users

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
