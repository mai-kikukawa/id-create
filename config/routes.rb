Rails.application.routes.draw do
  get 'messages/index'
  
  root to: 'static_pages#home'
  get    'signup', to: 'users#new'
  get    'login' , to: 'sessions#new'
  post   'login' , to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  resources :users do
    member do
      get :messages
    end
  end
  resources :messages
  resources :sessions, only: [:new, :create, :destroy]
end