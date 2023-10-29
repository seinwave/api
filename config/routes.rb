Rails.application.routes.draw do
  get     'map_data/plants',                to: "plants#mapped_plants"
  get     '/signup',                        to: "users#new"
  get     '/login',                         to: "sessions#new"
  delete  '/logout',                        to: "sessions#destroy"
  post    '/login',                         to: "sessions#create"
  get     '/magic_link',                    to: "sessions#edit",          as: "magic_link"
  get     '/map',                           to: "map#show"
  post    'map_data/info_panel/:id',        to: "info_panel#create"
  post    'favorite_cultivar/:id',          to: "users#toggle_favorite",  as: "favorite_cultivar"
  post    'hide_info',                      to: "info_panel#hide",        as: "hide_info_panel"
  resources :users 
  resources :cultivars
  resources :favorites,                     only: [:create]
  delete '/favorites/:id',                  to: 'favorites#destroy',      as: "delete_favorite"
  root "cultivars#index"
end
