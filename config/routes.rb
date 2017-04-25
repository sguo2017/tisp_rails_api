Rails.application.routes.draw do

  resources :goods_catalogs
  resources :favorites
  resources :favorites_searches
  
  resources :sys_msgs
  resources :sys_msgs_searches
  
  resources :goods
  resources :goods_searches
  
  resources :chats
  resources :order_items
  resources :orders
  
  #devise_for :users

  devise_for :users, controllers:{registrations:'users/registrations', sessions:'users/sessions',passwords:'users/passwords'}

  namespace :api do
    namespace :goods do
      resources :serv_offers, only: [:index, :create, :show, :update, :destroy] 
    end
    namespace :sys do
      resources :sys_msgs, only: [:index, :create, :show, :update, :destroy]
    end
    namespace :session do
      resources :users, only: [:edit, :show, :update, :create]
	  match '/users/avatar/server_url' ,to: 'users#avatar_server_url', via: [:get,:post]
    end
    namespace :me do
      resources :favorites, only: [:index, :create, :show, :update, :destroy]
    end
    namespace :orders do
      resources :orders, only: [:index, :create, :show, :update, :destroy]
      resources :order_items, only: [:index, :create, :show, :update, :destroy]
    end
    namespace :chats do
      resources :chats, only: [:index, :create, :show, :update, :destroy]
    end
  end
   resources :admin_users
   resources :goods_searches
   resources :sys_msgs_searches
   resources :favorites_searches
  
  root "goods#index"
end
