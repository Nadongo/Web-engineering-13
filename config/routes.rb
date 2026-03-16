Rails.application.routes.draw do
  get 'labels/index'
  get 'labels/new'
  get 'labels/edit'
  root 'tasks#index'
  resources :users, only: [:new, :create, :show, :edit, :update]
  resources :sessions, only: [:new, :create, :destroy]
  resources :tasks
  
  resources :labels
  
  namespace :admin do
    resources :users
  end
end