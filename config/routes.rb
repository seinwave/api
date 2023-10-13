Rails.application.routes.draw do
  get '/signup', to: "users#new"
  get '/magic_login', to: "sessions#create", as: "magic_login"
  get '/magic_signup', to: "sessions#edit", as: "magic_signup"
  resources :users 
  resources :cultivars

  root "cultivars#index"
end
