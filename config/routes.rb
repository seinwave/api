Rails.application.routes.draw do
  get '/signup', to: "users#new"
  resources :users 
  resources :cultivars
  resources :sessions, only: [:create, :destroy]
  # root "articles#index"
end
