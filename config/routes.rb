Rails.application.routes.draw do
  get '/signup', to: "users#new"
  resources :users 
  resources :cultivars
  resources :sessions

  root "cultivars#index"
end
