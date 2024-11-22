require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  post 'cart',                to: 'carts#create'
  get  'cart',                to: 'carts#list_products'
  post 'cart/add_item',       to: 'carts#add_item'
  delete 'cart/:product_id',  to: 'carts#remove_item', as: 'remove_item_from_cart'

  resources :products
  get "up" => "rails/health#show", as: :rails_health_check
  root "rails/health#show"
end
