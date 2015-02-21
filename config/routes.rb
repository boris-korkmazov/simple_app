Rails.application.routes.draw do

  resources :users do
    get :following, :followers, on: :member
  end

  resources :sessions, only: [:new, :create, :destroy]

  resources :microposts, only: [:create, :destroy]

  resources :relationships, only: [:create, :destroy]

  root 'static_pages#home'

  get '/help', to: "static_pages#help", as: :help

  match '/about', to: 'static_pages#about', via: 'get'

  match '/contact', to: 'static_pages#contact', via: 'get'

  match '/signup', to: 'users#new', via: 'get'

  match '/signin', to: 'sessions#new', via: 'get'

  match '/signout', to: 'sessions#destroy', via: 'delete'

end
