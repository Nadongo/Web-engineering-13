Rails.application.routes.draw do
  # Sets the root URL to task list screen
  root 'tasks#index'
  
  # Automatically generates all the necessary paths (CRUD Views)
  resources :tasks
end