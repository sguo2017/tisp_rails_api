require 'sidekiq/web'
Rails.application.routes.draw do

  resources :comments
  resources :friends
  resources :reports
  resources :suggestions
  resources :sms_sends
  resources :sms_sends_searches

  resources :favorites
  resources :favorites_searches

  resources :sys_msgs
  resources :sys_msgs_searches
  resources :sys_msgs_timelines

  resources :goods
  resources :goods_show
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

  devise_for :users, :skip => :registrations, controllers:{registrations:'users/registrations', sessions:'users/sessions',passwords:'users/passwords'}

  concern :paginatable do
    get '(page/:page)', :action => :show, :on => :collection, :as => ''
  end
  
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
      resources :registrations, only: [:update, :create, :validate_phone, :validate_email]
	    resources :sessions, only: [:create, :destroy, :smslogin, :tokenlogin, :phone_login]
	    resources :passwords, only: [:create, :update]
	    resources :users_behaviors, only: [:index, :show, :create, :update, :destroy, :client_ip]
	    resources :phone_call, only: [:update]
      resources :users, only: [:show, :update]
      resources :invitation_code, only: [:create, :validate_code]
      match '/image_server_url' ,to: 'registrations#image_server_url', via: [:get,:post]
	    match '/sms_login' ,to: 'sessions#sms_login', via: [:post]
	    match '/token_login' ,to: 'sessions#token_login', via: [:post]
      match '/phone_login' ,to: 'sessions#phone_login', via: [:post]
	    match '/client_ip' ,to: 'users_behaviors#client_ip', via: [:get, :post]
      match '/validate_code', to: 'invitation_code#validate_code', via: [:post]
      match '/validate_email', to: 'registrations#validate_email', via: [:post]
      match '/validate_phone', to: 'registrations#validate_phone', via: [:post]
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
      resources :chat_rooms do
        resources :chat_messages, :concerns => :paginatable
      end
    end
	  namespace :goods_catalogs do
      resources :goods_catalogs, only: [:index, :create, :show, :update, :destroy]
	    match '/json' ,to: 'goods_catalogs#catalogs_json', via: [:get,:post]
    end
    namespace :sys_msgs_timelines do
      resources :sys_msgs_timelines
      resources :sys_msgs_queries
    end
    namespace :suggestion do 
      resources :suggestions, only: [:index, :create, :show, :update, :destroy] 
      resources :reports, only: [:index, :create, :show, :update, :destroy] 
      resources :comments, only: [:index, :create, :show, :update, :destroy] 
    end
    namespace :friends do 
      resources :friends, only: [:index, :create, :show, :update, :destroy, :friend_list] 
      match '/friend_list', to: 'friends#friend_list', via: [:post]
    end
  end

  root "goods#index"
  mount Sidekiq::Web => '/sidekiq'
end
