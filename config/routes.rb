Rails.application.routes.draw do
  root 'home#index'

  resources :miles_offers
  resources :ticket_purchases, only: [:create, :update, :destroy]

  resources :tickets do
    member do
      get :buy
    end 
  end

  resources :airlines do
    member do
      get :new_batch
      post :create_batch
      post :edit_batch
    end
  end

  resources :users do
    member do
      # resource
      get :miles
      get :my_tickets, to:'users#my_tickets', as: 'my_tickets'
      post :redeem_miles
      post :sell_miles
      post :buy_miles
    end
  end
  
  get 'bank_account', to: 'users#bank_account'
  
  scope 'manage' do
    get 'show', to: 'manage#site_show', as: 'site'
    patch 'update', to: 'manage#site_update', as: 'update_site'
    get 'dashboard', to: 'manage#dashboard'
  end

  resources :sessions, only: [:new, :create, :destroy]
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
end
