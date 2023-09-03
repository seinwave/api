# frozen_string_literal: true

Rails.application.routes.draw do
  root 'map#index'

  resources :plants
  resources :plant_statuses

  resources :map
end
