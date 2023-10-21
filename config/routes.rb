Rails.application.routes.draw do
  get     'map_data/plants',                to: "plants#mapped_plants"
  get     '/signup',                        to: "users#new"
  get     '/login',                         to: "sessions#new"
  delete  '/logout',                        to: "sessions#destroy"
  post    '/login',                         to: "sessions#create"
  get     '/magic_link',                    to: "sessions#edit", as: "magic_link"
  get     '/map',                           to: "map#show"
  get     'map_data/info_panel/:id',        to: "info_panel#show"
  resources :users 
  resources :cultivars

  root "cultivars#index"
end
