Rails.application.routes.draw do
  get     'map_data/plants',                to: "plants#mapped_plants"
  get     'map_data/cultivars',             to: "cultivars#query",        as: "query_cultivars"
  get     '/signup',                        to: "users#new"
  get     '/login',                         to: "sessions#new"
  delete  '/logout',                        to: "sessions#destroy"
  post    '/login',                         to: "sessions#create"
  get     '/magic_link',                    to: "sessions#edit",          as: "magic_link"
  get     '/map',                           to: "map#show"
  get     'map_data/info_panel/:id',        to: "info_panel#create",      as: "info_panel", defaults: {format: :turbo_stream}
  delete  'favorite_cultivar/:id',          to: "favorites#destroy",      as: "delete_favorite"
  post    'favorite_culitvar/:id',          to: "favorites#create",       as: "add_favorite"
  post    'hide_info',                      to: "info_panel#hide",        as: "hide_info_panel"
  resources :users 
  resources :cultivars
  root "map#show"
end
