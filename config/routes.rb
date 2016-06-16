Rails.application.routes.draw do
  get 'messages/index'

  root to: 'messages#index'
  get    'signup', to: 'users#new'
  get    'login' , to: 'sessions#new'
  post   'login' , to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :messages , except: [:index, :new]
end