Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'users/new'
  root 'static_pages#home'
  get '/home', to: 'static_pages#home'
  get 'help', to: 'static_pages#help'
  get 'about', to: 'static_pages#about'
  get 'contact', to: 'static_pages#contact'

  get '/signup', to: 'users#new'

  resources :users do
    member do
      get :following, :followers
    end
  end

  # Usersリソースに必要なアクションをすべて利用するように
  resources :users

  resources :account_activations, only: [:edit]

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :microposts, only: [:create, :destroy]
  resources "password_resets", only: [:new, :create, :edit, :update]
  resources :relationships, only: [:create, :destroy]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
