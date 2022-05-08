Rails.application.routes.draw do
  root "locations#index"

  resources :locations
  resources :users, except: [:index]

  get    "/login",  to: "sessions#new"
  post   "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  namespace :admin do
    resources :maps, :loot_containers
    resources :users, except: [:new, :create, :show]
  end
end
