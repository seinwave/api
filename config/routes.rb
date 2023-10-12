Rails.application.routes.draw do
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  get '/signup', to: "users#new"
  resources :users 
  resources :cultivars
  # root "articles#index"
end
