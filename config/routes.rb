Rails.application.routes.draw do
  get 'messages/index'
  
  root to: 'static_pages#home'
  get    'signup', to: 'users#new'
  get    'login' , to: 'sessions#new'
  post   'login' , to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  resources :users do
    member do
      resources :messages
    end
  end
  resources :sessions, only: [:new, :create, :destroy]
end