Rails.application.routes.draw do
  resources :miles_offers
  root 'home#index'

  resources :tickets
  resources :airlines do
    member do
      get :new_batch
      post :create_batch
      post :edit_batch
    end
  end
  resources :users do
    member do
      get :miles
      post :redeem_miles
      post :sell_miles
      post :buy_miles
    end
  end
  
  
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
