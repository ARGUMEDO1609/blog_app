Rails.application.routes.draw do

  root "posts#index"

  resources :posts do
    collection do
      get :search
    end
    resources :comments, only: [:create]
  end

  resources :comments, only: [] do
    resources :comments, only: [:create]
  end

  resources :reactions, only: [:create]
    resources :notifications, only: [:index, :update]
  devise_for :users
end
