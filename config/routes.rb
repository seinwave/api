Rails.application.routes.draw do
  get '/signup', to: "users#new"
  resources :users 
  resources :cultivars
  # root "articles#index"
end
