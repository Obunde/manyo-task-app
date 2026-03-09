Rails.application.routes.draw do
  get 'labels/index'
  get 'labels/new'
  get 'labels/create'
  get 'labels/edit'
  get 'labels/update'
  get 'labels/destroy'
  root 'sessions#new'

  resources :tasks
  resources :users, only: [:new, :create, :show, :edit, :update, :destroy]
  resource :session, only: [:new, :create, :destroy]
  resources :labels
  
  namespace :admin do
    resources :users
  end
end
