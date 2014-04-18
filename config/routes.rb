GlobalFriends::Application.routes.draw do
  devise_for :users

  get 'property_filter', to: 'properties#index', as: 'property_filter'
  resources :properties
  root to: 'properties#index'
end
