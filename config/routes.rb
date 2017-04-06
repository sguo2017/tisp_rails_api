Rails.application.routes.draw do

  resources :serv_offers
  #devise_for :users

  devise_for :users, controllers:{registrations:'users/registrations', sessions:'users/sessions'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :serv do
      resources :serv_offers, only: [:index, :create, :show, :update, :destroy] 
    end
  end

end
