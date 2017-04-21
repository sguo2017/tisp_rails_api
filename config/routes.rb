Rails.application.routes.draw do

  resources :favorites
  resources :chats
  resources :order_items
  resources :deals
  resources :sys_msgs
  resources :serv_offers

  #devise_for :users

  devise_for :users, controllers:{registrations:'users/registrations', sessions:'users/sessions',passwords:'users/passwords'}

  namespace :api do
    namespace :serv do
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
    namespace :order do
      resources :deals, only: [:index, :create, :show, :update, :destroy]
      resources :order_items, only: [:index, :create, :show, :update, :destroy]
    end
    namespace :chat do
      resources :chats, only: [:index, :create, :show, :update, :destroy]
    end
  end
  
  resources :serv_offers_searches
  resources :sys_msgs_searches
  resources :favorites_searches
  root "serv_offers#index"
end
