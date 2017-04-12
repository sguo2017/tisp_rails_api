Rails.application.routes.draw do

  resources :sys_msgs
  resources :serv_offers

  #devise_for :users

  devise_for :users, controllers:{registrations:'users/registrations', sessions:'users/sessions'}

  namespace :api do
    namespace :serv do
      resources :serv_offers, only: [:index, :create, :show, :update, :destroy] 
    end
    namespace :sys do
      resources :sys_msgs, only: [:index, :create, :show, :update, :destroy]
    end
    namespace :session do
      resources :users,only: [:edit, :show, :update]
    end
  end

  root "serv_offers#index"
end
