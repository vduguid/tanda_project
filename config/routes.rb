Rails.application.routes.draw do
  root "sessions#new"

  get '/home' => 'organizations#index'
  get '/home/new' => 'organizations#new'
  post '/home/new_organization' => 'organizations#create'
  get 'home/join/' => 'organizations#join'
  get 'home/leave' => 'organizations#leave'

  get '/home/edit/:id' => 'organizations#edit'
  patch '/home/update/:id' => 'organizations#update'

  get '/home/delete/:id' => 'organizations#destroy'

  get '/organization/:id/shifts' => 'organizations#shifts'

  get '/login' => 'sessions#new'

  post 'login' => "sessions#create"

  get '/logout' => "sessions#destroy"

  resources :users
  resources :organizations do
    resources :shifts
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
