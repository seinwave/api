Rails.application.routes.draw do
  get '/signup', to: "users#new"
  get '/login', to: "sessions#new"
  post '/login', to: "sessions#create"
  patch '/magic_signup', to: "session#edit"
  resources :users 
  resources :cultivars

  root "cultivars#index"
end
