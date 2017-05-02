Rails.application.routes.draw do

  resources :sms_sends
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
  resources :admin_users
  resources :goods_searches
  resources :sys_msgs_searches
  resources :favorites_searches
 
  #devise_for :users

  devise_for :users, controllers:{registrations:'users/registrations', sessions:'users/sessions',passwords:'users/passwords'}

  namespace :api do
    namespace :goods do
      resources :serv_offers, only: [:index, :create, :show, :update, :destroy] 
    end
    namespace :sys do
      resources :sys_msgs, only: [:index, :create, :show, :update, :destroy]
      resources :sms_sends, only: [:index, :create, :show, :update, :destroy]
    end
    namespace :users do
      resources :registrations, only: [:update, :create]
	  resources :sessions, only: [:create, :destroy]
	  match '/image_server_url' ,to: 'registrations#image_server_url', via: [:get,:post]
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
	namespace :goods_catalogs do
      resources :goods_catalogs, only: [:index, :create, :show, :update, :destroy]
	  match '/json' ,to: 'goods_catalogs#catalogs_json', via: [:get,:post]
    end
  end
  
  root "goods#index"
end
