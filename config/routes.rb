Rails.application.routes.draw do

  resources :favorites
  resources :deal_chat_details
  resources :deal_chats
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
      resources :deal_chats, only: [:index, :create, :show, :update, :destroy]
      resources :deal_chat_details, only: [:index, :create, :show, :update, :destroy]
    end
  end
  
  resources :serv_offers_searches
  root "serv_offers#index"
end
