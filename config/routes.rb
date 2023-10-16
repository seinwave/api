Rails.application.routes.draw do
  get 'map/show'
  get     '/signup',        to: "users#new"
  get     '/login',         to: "sessions#new"
  delete  '/logout',        to: "sessions#destroy"
  post    '/login',         to: "sessions#create"
  get     '/magic_link',    to: "sessions#edit", as: "magic_link"
  get     '/map',           to: "map#show"
  resources :users 
  resources :cultivars

  root "cultivars#index"
end
