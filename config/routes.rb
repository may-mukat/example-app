Rails.application.routes.draw do
  root "locations#index"

  resources :locations
  resources :users, except: [:index, :edit, :update]
  get    "users/:id/edit/email",    to: "users#edit_email",      as: "user_edit_email"
  get    "users/:id/edit/password", to: "users#edit_password",   as: "user_edit_password"
  get    "users/:id/deactive",      to: "users#deactive",        as: "user_deactive"
  post   "users/:id/email",         to: "users#update_email",    as: "user_update_email"
  post   "users/:id/password",      to: "users#update_password", as: "user_update_password"

  get    "/login",  to: "sessions#new"
  post   "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  namespace :admin do
    resources :maps, :loot_containers
    resources :users, only: [:new, :create, :show] do

    end
  end
end
