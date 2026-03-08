Rails.application.routes.draw do
  root 'tasks#index'
  
  resources :tasks
  resources :users, only: [:new, :create, :show, :edit, :update]
  
  # Login / Logout routes
  resources :sessions, only: [:new, :create, :destroy]
  
  # ADD THIS LINE: Failsafe to catch the GET request and log the user out
  get '/sessions/:id', to: 'sessions#destroy'
  
  namespace :admin do
    resources :users
  end
end