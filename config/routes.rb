Rails.application.routes.draw do

  resources :sms_sends
  resources :sms_sends_searches
  
  resources :favorites
  resources :favorites_searches
  
  resources :sys_msgs
  resources :sys_msgs_searches
  
  resources :goods
  resources :goods_searches
  resources :goods_catalogs
  resources :goods_catalogs_searches
  
  resources :chats
  resources :chats_searches
  
  resources :order_items
  resources :orders
  resources :orders_searches
  
  resources :admin_users
  resources :users_behaviors
  resources :users_searches
  match '/admin_users/lock_proc/:id' ,to: 'admin_users#lock_proc', via: [:get,:post]
 
  #devise_for :users

  devise_for :users, controllers:{registrations:'users/registrations', sessions:'users/sessions',passwords:'users/passwords'}

  namespace :api do
    namespace :goods do
      resources :serv_offers, only: [:index, :create, :show, :update, :destroy] 
      resources :goods_catalogs, only: [:index]
    end
    namespace :sys do
      resources :sys_msgs, only: [:index, :create, :show, :update, :destroy]
      resources :sms_sends, only: [:index, :create, :show, :update, :destroy]
    end
    namespace :users do
      resources :registrations, only: [:update, :create]
	  resources :sessions, only: [:create, :destroy, :smslogin]
	  resources :users_behaviors, only: [:index, :show, :create, :update, :destroy, :client_ip]
	  match '/image_server_url' ,to: 'registrations#image_server_url', via: [:get,:post]
	  match '/sms_login' ,to: 'sessions#sms_login', via: [:post]
	  match '/client_ip' ,to: 'users_behaviors#client_ip', via: [:get, :post]
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
