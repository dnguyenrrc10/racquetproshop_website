Rails.application.routes.draw do
  devise_for :users

  # Public pages
  root 'pages#home'
  get 'about',   to: 'pages#about'
  get 'contact', to: 'pages#contact'

  # Catalog
  resources :categories, only: %i[index show]
  resources :products,   only: %i[index show]
 resources :orders, only: [:index, :show, :new, :create]
  # Cart (SINGULAR, uses CartController)
  resource :cart, only: [:show], controller: 'cart'

  post   'cart/add/:product_id',    to: 'cart#add',    as: 'add_to_cart'
  patch  'cart/update/:product_id', to: 'cart#update', as: 'update_cart_item'
  delete 'cart/remove/:product_id', to: 'cart#remove', as: 'remove_from_cart'
  delete 'cart/clear',              to: 'cart#clear',  as: 'clear_cart'

  # Orders
  resources :orders, only: %i[index show new create]
  resources :products, only: %i[index show]


  # Admin
  namespace :admin do
    root to: 'dashboard#index'
    resources :categories
    resources :products
    resources :customers, only: [:index, :show]
    resources :pages, only: [:index, :edit, :update], param: :slug
  end
end
